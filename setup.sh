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

# Setup local User.xcconfig
USER_CONFIG_PATH="HobbyHangar/Configuration/User.xcconfig"

echo "Checking for User.xcconfig..."
if [ ! -f "$USER_CONFIG_PATH" ]; then
	echo "Creating local configuration file at $USER_CONFIG_PATH..."
	
	# Check for identities in the keychain
	TEAM_ID=""
	if command -v security >/dev/null 2>&1; then
		echo "Checking Keychain for 'Apple Development' certificates..."
		# Get lines containing "Apple Development", extract content between last parens inside quotes
		POSSIBLE_IDS=$(security find-identity -v -p codesigning 2>/dev/null | grep "Apple Development" | sed -n 's/.*(\(.*\))"/\1/p' | sort -u || true)
		
		if [ -n "$POSSIBLE_IDS" ]; then
			ID_COUNT=$(echo "$POSSIBLE_IDS" | wc -l | tr -d ' ')
			if [ "$ID_COUNT" -eq 1 ]; then
				read -r -p "Found Team ID: $POSSIBLE_IDS. Use this? [Y/n] " CONFIRM
				if [[ ! "$CONFIRM" =~ ^[Nn] ]]; then
					TEAM_ID="$POSSIBLE_IDS"
				fi
			else
				echo "Found multiple Team IDs:"
				echo "$POSSIBLE_IDS"
				echo ""
			fi
		fi
	fi

	if [ -z "$TEAM_ID" ]; then
		echo "To configure signing, please enter your Apple Development Team ID."
		echo "(You can find this at https://developer.apple.com/account or by running 'security find-identity -v -p codesigning')"
		read -r -p "Team ID (leave blank to skip): " TEAM_ID || true
	fi
	
	# Prompt for Bundle ID
	read -r -p "Bundle Identifier (leave blank to use default 'com.nleach.HobbyHangar'): " BUNDLE_ID || true
	
	# Create the directory if it doesn't exist
	mkdir -p "$(dirname "$USER_CONFIG_PATH")"

	cat <<CONFIG_EOF > "$USER_CONFIG_PATH"
//
//  User.xcconfig
//  HobbyHangar
//
//  Local user settings - this file should be ignored by git.
//

// Set your development team ID here to avoid changing the project file.
// Get your Team ID from https://developer.apple.com/account
// or by running:
// security find-identity -v -p codesigning

HH_DEVELOPMENT_TEAM = ${TEAM_ID}

// Bundle Identifier to allow local overrides
// HH_BUNDLE_IDENTIFIER = ${BUNDLE_ID:-com.nleach.HobbyHangar}

// Code Sign Style
// Default is set to "Manual" in HobbyHangar.xcconfig
// Uncomment and override if needed (options: Automatic, Manual)
// HH_CODE_SIGN_STYLE = Automatic

// Provisioning Profile Specifier (iOS)
// Default is set to "match AppStore com.nleach.HobbyHangar" in HobbyHangar.xcconfig
// Uncomment and override if needed (e.g. "match Development com.example.App")
// HH_PROVISIONING_PROFILE_SPECIFIER_IOS = match AppStore \$(HH_BUNDLE_IDENTIFIER)
CONFIG_EOF

	if [ -n "$BUNDLE_ID" ]; then
		# Use sed to uncomment and set the bundle ID
		sed -i '' "s|// HH_BUNDLE_IDENTIFIER = .*|HH_BUNDLE_IDENTIFIER = $BUNDLE_ID|g" "$USER_CONFIG_PATH"
	fi

	echo "Created $USER_CONFIG_PATH."
else
	echo "$USER_CONFIG_PATH already exists. Skipping creation."
fi

echo "Setup complete!"

