# AGENTS.md

## Project overview

- Hobby Hangar is a recreational UAV pilot logbook.
- It is a native iOS application built with Swift and SwiftUI.
- Core features: Pilot profile, flight logging, fleet management, and battery tracking for recreational UAV pilots.
- Follow the project constitution in `.specify/memory/constitution.md`.

## Dev environment tips

- Run `./setup.sh` on a new machine. It installs `swiftlint`, installs
  `pre-commit`, copies git hooks, and creates local signing config if needed.
- Keep local signing overrides in `HobbyHangar/Configuration/User.xcconfig`.
  Do not commit local signing changes.
- All commits must be GPG-signed. Do not use `--no-gpg-sign`. If a Codex
  session cannot present the GPG passphrase prompt, launch an interactive local
  shell for the user to enter the passphrase. Prefer iTerm2 via AppleScript when
  available; fall back to Terminal if iTerm2 is unavailable. In the launched
  shell, set `GPG_TTY=$(tty)` and pass `-S` explicitly when running
  `rtk git commit -S ...` or `rtk git commit --amend --no-edit -S`; do not rely
  on `commit.gpgsign` alone. After committing, verify the latest commit reports
  a good signature with `rtk git log -1 --show-signature` or `%G?` before
  reporting success. If a commit is accidentally created unsigned, immediately
  amend it with `rtk git commit --amend --no-edit -S`.

## Testing instructions

- CI is defined in `.github/workflows/ci.yml`.
- Run `swiftlint` before committing.
- Prefer the Xcode MCP for builds, tests, and simulator workflows.
- If the Xcode MCP is unavailable or cannot perform the needed action, run
  tests with
  `xcodebuild -project HobbyHangar.xcodeproj -scheme HobbyHangar -destination "platform=iOS Simulator,name=iPhone 17" -skipPackagePluginValidation clean test`.
- Add or update tests in `HobbyHangarTests/` or `HobbyHangarUITests/` for any
  behavior change.

## PR instructions

- Keep SwiftUI, accessibility, and Apple HIG decisions aligned with the
  constitution.
- Do not merge changes with failing lint or test results.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan.
<!-- SPECKIT END -->
