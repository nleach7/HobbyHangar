# Hobby Hangar
Hobby Hangar provides flight logging, fleet management, and battery tracking for recreational UAV pilots.

**Setup**
- **Prerequisites:** Homebrew and Python (with `pip`) should be installed.
- **Install repository dependencies:** make the setup script executable and run it from the repository root:
```bash
chmod +x setup.sh
./setup.sh
```
- **What it does:** installs `swiftlint` via Homebrew, installs `pre-commit` with `pip`, copies git hooks from `./.githooks` to `.git/hooks`, makes them executable, and runs `pre-commit install` to enable hooks.

**Code Signing**
To build the app on a physical device, you need to configure your local signing identity.
Run `./setup.sh` and follow the interactive prompts to create `HobbyHangar/Configuration/User.xcconfig`.

Alternatively, you can manually create the file:
1. Create `HobbyHangar/Configuration/User.xcconfig` if it doesn't exist (this file is `.gitignore`d).
2. Add your local configuration settings:
   ```properties
   // Your Apple Development Team ID (from `security find-identity -v -p codesigning`)
   DEVELOPMENT_TEAM = YOUR_TEAM_ID

   // Your unique Bundle Identifier (e.g. com.yourname.HobbyHangar)
   HH_BUNDLE_IDENTIFIER = com.nleach.HobbyHangar

   // Provisioning Profile Specifier
   // Leave blank for Automatic Signing, or set a specific profile name (e.g. "match AppStore com.example.App")
   HH_PROVISIONING_PROFILE_SPECIFIER =
   ```
