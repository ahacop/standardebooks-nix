.PHONY: check-version

check-version:
	@pinned=$$(grep -oP 'standardebooks==\K[^"]+' pyproject.toml); \
	latest=$$(curl -fsSL https://pypi.org/pypi/standardebooks/json | jq -r '.info.version'); \
	echo "pinned: $$pinned"; \
	echo "latest: $$latest"; \
	if [ "$$pinned" = "$$latest" ]; then \
		echo "up to date"; \
	else \
		echo "update available"; \
		exit 1; \
	fi
