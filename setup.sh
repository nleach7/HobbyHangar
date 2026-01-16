#!/usr/bin/env bash
set -euo pipefail

GITHOOKS_DIR="$PWD/.githooks"
GIT_HOOKS_DIR="$PWD/.git/hooks"

if ! command -v brew >/dev/null 2>&1; then
	echo "Homebrew not found. Please install Homebrew first: https://brew.sh/" >&2
	exit 1
fi

echo "Installing SwiftLint..."
brew install swiftlint

# Install pre-commit (use pip or pip3)
echo "Installing pre-commit..."
if command -v pip >/dev/null 2>&1; then
	pip install pre-commit
elif command -v pip3 >/dev/null 2>&1; then
	pip3 install pre-commit
else
	echo "pip not found; skipping pre-commit installation." >&2
fi

# Run pre-commit install if available
if command -v pre-commit >/dev/null 2>&1; then
	echo "Running pre-commit install..."
	pre-commit install || echo "pre-commit install failed" >&2
else
	echo "pre-commit not available; skipping pre-commit install."
fi

if [ ! -d "$GITHOOKS_DIR" ]; then
	echo "No .githooks directory at $GITHOOKS_DIR — nothing to move."
else
	mkdir -p "$GIT_HOOKS_DIR"
	echo "Moving hook files from $GITHOOKS_DIR to $GIT_HOOKS_DIR"
	shopt -s nullglob
	files=("$GITHOOKS_DIR"/*)
	if [ ${#files[@]} -eq 0 ]; then
		echo "No files found in $GITHOOKS_DIR."
	else
		for f in "${files[@]}"; do
			cp -a "$f" "$GIT_HOOKS_DIR/"
			chmod +x "$GIT_HOOKS_DIR/$(basename "$f")"
			echo "Copied and made executable: $(basename "$f")"
		done
	fi
	shopt -u nullglob
fi

echo "Setup complete."

