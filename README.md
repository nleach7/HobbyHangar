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
