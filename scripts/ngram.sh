#!/usr/bin/env bash

if [ "$1" = "" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Usage: se-ext ngram <term> [other-term] [--corpus en-US|en-GB] [--json]"
  echo ""
  echo "Show how a word's usage frequency changed over time in the Google Books"
  echo "Ngram corpus."
  echo ""
  echo "With two terms it shows both usage curves and how they relate (crossover,"
  echo "current ratio). With one term it shows that form's curve alone. Both"
  echo "en-US and en-GB are queried by default (SE matches the book's language)."
  echo ""
  echo "OPTIONS"
  echo "  --corpus en-US|en-GB   Query only one corpus (default: both)"
  echo "  --json                 Emit the computed signals as JSON"
  echo "  -h, --help             Show this help"
  echo ""
  echo "WHAT IT REPORTS"
  echo "  Per form:  a 1800-2019 sparkline, peak year, and how common the form is"
  echo "             in the latest year, named as a band (\"common\", \"uncommon\","
  echo "             \"rare\", \"very rare\", ...; see NOTES), or \"below floor by 2019\""
  echo "             if it dropped out of modern books, or \"below floor — no data\""
  echo "             if it never clears the floor."
  echo "  Per pair:  crossover year (when the second form overtook the first, or"
  echo "             never) and the current frequency ratio between them."
  echo ""
  echo "NOTES (data-only; tune in this script)"
  echo "  corpus floor    1e-9   series below this are omitted by the API -> no data;"
  echo "                         a form below it in the latest year reads as gone"
  echo "  frequency bands        latest-year frequency, per million words, named"
  echo "                         one band per power of ten:"
  echo "                           >=10000  extremely common      >=1   uncommon"
  echo "                           >=1000   very common           >=0.1 rare"
  echo "                           >=100    common                >=0.01 very rare"
  echo "                           >=10     moderately common     <0.01 extremely rare"
  echo "  Each sparkline is normalized to its own form's peak (shows shape, not"
  echo "  cross-form magnitude)."
  echo ""
  echo "EXIT STATUS"
  echo "  0   signals produced"
  echo "  5   no data: the queried form is below the corpus floor in every corpus"
  echo "  75  rate limited by the Ngram endpoint"
  echo "  1   error (network / bad response)    2  usage error"
  echo ""
  echo "EXAMPLES"
  echo "  se-ext ngram to-night tonight              Compare two forms over time"
  echo "  se-ext ngram shew                           One form's curve"
  echo "  se-ext ngram colour color --corpus en-GB    Pin one corpus"
  echo "  se-ext ngram doth does --json               Machine-readable signals"
  exit 0
fi

TERM_A=""
TERM_B=""
CORPORA="en-US,en-GB"
JSON_MODE=0

while [ $# -gt 0 ]; do
  case "$1" in
  --corpus)
    case "$2" in
    en-US | en-GB) CORPORA="$2" ;;
    *)
      echo "Error: --corpus must be en-US or en-GB (got '$2')" >&2
      exit 2
      ;;
    esac
    shift 2
    ;;
  --json)
    JSON_MODE=1
    shift
    ;;
  -h | --help)
    exec se-ext ngram --help
    ;;
  -*)
    echo "Unknown option: $1" >&2
    echo "Run 'se-ext ngram --help' for usage." >&2
    exit 2
    ;;
  *)
    if [ "$TERM_A" = "" ]; then
      TERM_A="$1"
    elif [ "$TERM_B" = "" ]; then
      TERM_B="$1"
    else
      echo "Error: too many terms (expected at most 2: <term> [other-term])" >&2
      exit 2
    fi
    shift
    ;;
  esac
done

if [ "$TERM_A" = "" ]; then
  echo "Error: no term given." >&2
  echo "Run 'se-ext ngram --help' for usage." >&2
  exit 2
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Error: python3 not found on PATH." >&2
  exit 1
fi

python3 - "$TERM_A" "$TERM_B" "$CORPORA" "$JSON_MODE" <<'PYEOF'
import json, sys, urllib.request, urllib.parse, urllib.error

TERM_A = sys.argv[1]            # first term
TERM_B = sys.argv[2] or None    # second term, optional
CORPORA = sys.argv[3].split(",")
JSON_MODE = sys.argv[4] == "1"

YEAR_START, YEAR_END = 1800, 2019
SMOOTHING = 3
FLOOR = 1e-9

BLOCKS = "▁▂▃▄▅▆▇█"
SUCCESS, NO_DATA = 0, 5
RATE_LIMITED = 75

def die(msg, code=1):
    print("Error: " + msg, file=sys.stderr)
    sys.exit(code)

def rate_limited(reason):
    print("Error: rate limited by the Ngram endpoint — %s" % reason, file=sys.stderr)
    sys.exit(RATE_LIMITED)

def fetch(content, corpus):
    """Hit the unofficial Ngram Viewer JSON endpoint. Returns a list (possibly
    empty); raises on transport/parse failure."""
    q = urllib.parse.urlencode({
        "content": content, "year_start": YEAR_START, "year_end": YEAR_END,
        "corpus": corpus, "smoothing": SMOOTHING})
    url = "https://books.google.com/ngrams/json?" + q
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (se-ext ngram)"})
    with urllib.request.urlopen(req, timeout=25) as r:
        if r.status != 200:
            raise RuntimeError("HTTP %s from Ngram endpoint" % r.status)
        data = json.load(r)
    if not isinstance(data, list):
        raise RuntimeError("unexpected response shape from Ngram endpoint")
    return data


def norm(s):
    # The endpoint normalizes punctuation ("to-night" -> "to - night"); match
    # on a space-stripped, lowercased key so omitted (below-floor) series don't
    # throw off positional assumptions.
    return s.lower().replace(" ", "")


def index_series(arr):
    out = {}
    for e in arr:
        out[norm(e.get("ngram", ""))] = e.get("timeseries") or []
    return out


def metrics(ts):
    if not ts or max(ts) <= 0:
        return None  # not present / below the corpus floor everywhere
    yrs = [YEAR_START + i for i in range(len(ts))]
    peak = max(ts)
    peak_year = yrs[ts.index(peak)]
    latest = ts[-1]
    # Absolute attestation: is the form still above the corpus floor in the
    # latest year, and at what frequency?
    return dict(latest=latest, peak=peak, peak_year=peak_year,
                per_million=latest * 1e6, attested_now=latest >= FLOOR, ts=ts)


def crossover(a_ts, b_ts):
    """First year the second form overtakes the first and stays above it for
    the rest of the series (guards against early-corpus noise)."""
    n = min(len(a_ts), len(b_ts))
    for i in range(n):
        if b_ts[i] > a_ts[i] and all(b_ts[j] >= a_ts[j] for j in range(i, n)):
            return YEAR_START + i
    return None


def spark(ts, cols=12):
    if not ts:
        return " " * cols
    n = len(ts)
    vals = []
    for c in range(cols):
        lo, hi = c * n // cols, (c + 1) * n // cols
        seg = ts[lo:hi] or ts[lo:lo + 1]
        vals.append(sum(seg) / len(seg))
    mx = max(vals)
    if mx <= 0:
        return BLOCKS[0] * cols
    return "".join(BLOCKS[max(0, min(int(round(v / mx * 7)), 7))] for v in vals)


# ---- gather signals per corpus ----
have_b = TERM_B is not None
content = TERM_A + ("," + TERM_B if have_b else "")
per = {}
for corp in CORPORA:
    try:
        arr = fetch(content, corp + "-2019")
    except urllib.error.HTTPError as e:
        if e.code in (429, 503):
            rate_limited("the endpoint returned HTTP %s for %s" % (e.code, corp))
        die("Ngram endpoint returned HTTP %s for %s" % (e.code, corp))
    except urllib.error.URLError as e:
        die("could not reach the Ngram endpoint (%s)" % e.reason)
    except Exception as e:  # JSON / shape errors
        die("could not read Ngram response for %s (%s)" % (corp, e))
    idx = index_series(arr)
    a_ts = idx.get(norm(TERM_A), [])
    b_ts = idx.get(norm(TERM_B), []) if have_b else []
    a = metrics(a_ts)
    b = metrics(b_ts) if have_b else None
    cross = crossover(a_ts, b_ts) if (a and b) else None
    ratio = (b["latest"] / a["latest"]) if (a and b and a["latest"] > 0) else None
    per[corp] = dict(a=a, b=b, cross=cross, ratio=ratio)

# "No data" = the queried form (TERM_A) is below the floor in every corpus.
has_a_data = any(d["a"] for d in per.values())
exit_code = SUCCESS if has_a_data else NO_DATA


def ratio_phrase(r):
    if r is None:
        return None
    if r >= 1:
        return ("now %.0f× as frequent" if r >= 10 else "now %.1f× as frequent") % r
    inv = (1 / r) if r else float("inf")
    return ("now %.0f× rarer" if inv >= 10 else "now %.1f× rarer") % inv


# Verbal frequency band for a latest-year frequency in occurrences per million
# words — one band per order of magnitude, from the corpus floor (~0.001/million,
# the bottom of "extremely rare") up to the commonest words (>=10000, i.e. >1%).
FREQ_BANDS = [
    (10000, "extremely common"),
    (1000, "very common"),
    (100, "common"),
    (10, "moderately common"),
    (1, "uncommon"),
    (0.1, "rare"),
    (0.01, "very rare"),
    (0.0, "extremely rare"),
]


def freq_word(pm):
    for lo, word in FREQ_BANDS:
        if pm >= lo:
            return word
    return FREQ_BANDS[-1][1]


# ---- JSON output ----
if JSON_MODE:
    def form_json(x):
        if x is None:
            return None
        return dict(present=True, latest=x["latest"], per_million=x["per_million"],
                    frequency=freq_word(x["per_million"]) if x["attested_now"] else None,
                    attested_now=x["attested_now"], peak=x["peak"],
                    peak_year=x["peak_year"], sparkline=spark(x["ts"]))
    out = dict(
        term=TERM_A, other_term=TERM_B, floor=FLOOR,
        params=dict(smoothing=SMOOTHING),
        exit_code=exit_code, corpora={})
    for corp, d in per.items():
        out["corpora"][corp] = dict(
            crossover=d["cross"], ratio_other_term=d["ratio"],
            term=form_json(d["a"]),
            other_term=form_json(d["b"]) if have_b else None)
    print(json.dumps(out, indent=2, ensure_ascii=False))
    sys.exit(exit_code)

# ---- human output ----
lw = max(len(TERM_A), len(TERM_B) if have_b else 0)
hdr = "  %s%s" % (TERM_A, (" vs " + TERM_B) if have_b else "")
print()
print(hdr)
print("  %s · floor %.0e" % (" · ".join(c + "-2019" for c in CORPORA), FLOOR))
print()


def a_annot(a):
    if a is None:
        return "below floor — no data"
    base = "peaked %d · " % a["peak_year"]
    if not a["attested_now"]:
        return base + "below floor by 2019"
    return base + "%s in 2019" % freq_word(a["per_million"])


def b_annot(d):
    b = d["b"]
    if b is None:
        return "below floor — no data"
    parts = ["crossover %d" % d["cross"] if d["cross"] else "no crossover"]
    rp = ratio_phrase(d["ratio"])
    if rp:
        parts.append(rp)
    return " · ".join(parts)


for corp in CORPORA:
    d = per[corp]
    print("  %-5s %-*s  %s  %s" % (
        corp, lw, TERM_A, spark(d["a"]["ts"] if d["a"] else None), a_annot(d["a"])))
    if have_b:
        print("  %-5s %-*s  %s  %s" % (
            "", lw, TERM_B, spark(d["b"]["ts"] if d["b"] else None), b_annot(d)))

sys.exit(exit_code)
PYEOF
