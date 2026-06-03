<!--
Sync Impact Report
- Version change: 1.1.0 -> 1.1.1
- Modified principles:
  - I. SwiftUI Feature Boundaries -> I. SwiftUI Feature Boundaries
  - V. Observable Releases -> V. Observable Releases
- Added sections:
  - None
- Removed sections:
  - None
- Templates requiring updates:
  - ✅ no template updates required
- Follow-up TODOs:
  - None
-->
# Hobby Hangar Constitution

## Core Principles

### I. SwiftUI Feature Boundaries
All user-facing behavior MUST preserve clear boundaries between layers. SwiftUI
views render state and forward user intent, view models own presentation state,
services coordinate domain workflows, and repositories isolate persistence or
external integrations. Dependencies MUST be resolved through `FactoryKit`
registrations or explicit initializer injection seams for previews and tests.
UI implementation MUST use current Swift and SwiftUI language features, APIs,
and architectural patterns that are stable for the app's deployment target
instead of introducing legacy UIKit-era patterns by default. Apple Human
Interface Guidelines MUST be followed as closely as reasonably possible for
navigation, layout, motion, feedback, accessibility, and platform conventions,
with any deliberate deviation justified in the plan. Rationale: this keeps
features composable, prevents UI-driven side effects, and aligns the product
with modern Apple platform expectations.

### II. Main-Actor State Ownership
Shared application, navigation, and session state MUST have an explicit owner,
and mutations to UI-observed state MUST happen on the main actor. Async work
MUST cross actor boundaries intentionally, and views MUST NOT hide persistence,
network, or telemetry side effects inside rendering code. Rationale: mobile
lifecycle regressions usually come from ambiguous ownership and race-prone state
updates.

### III. Tests Gate Behavior Changes
Every behavior change MUST ship with automated coverage at the lowest effective
layer using `Testing`, `XCTest`, or both. View model and service changes require
focused unit tests, while lifecycle, persistence, dependency-injection, or
telemetry flows require integration-style coverage. Bug fixes MUST include a
regression test. Rationale: the repository already relies on mocks, stubs, and
structured logging, so untested changes are a quality regression.

### IV. Privacy-Safe Local-First Data Handling
Any feature that touches pilot, flight, fleet, or battery data MUST define its
local persistence behavior, background/offline behavior, and failure recovery
before implementation begins. Logs and analytics MUST exclude secrets, signing
material, tokens, and personally identifying or flight-sensitive payloads unless
an explicit approved requirement says otherwise. Rationale: this app manages
personal operational data and must remain trustworthy when the device is
offline, suspended, or resumed.

### V. Observable Releases
State-changing, persistence, sync, and lifecycle transitions MUST emit
structured diagnostics that are useful in debug builds and safe in production
handlers. Every implementation plan MUST name the lint, build, and automated
test commands to run, plus any manual simulator or device validation required
for lifecycle-sensitive flows. Validation for user-facing changes MUST also
include a review of HIG alignment, accessibility behavior, and use of current
SwiftUI platform conventions. Rationale: repeatable verification and diagnostic
coverage are required to ship native app changes safely.

## Platform Standards

Hobby Hangar is a native iOS application written in Swift and built around
SwiftUI. New work MUST align with the existing stack unless the implementation
plan documents a justified exception in Complexity Tracking.

- Swift and SwiftUI code MUST follow the latest stable best practices supported
  by the project's deployment target and toolchain.
- New UI SHOULD prefer native SwiftUI controls, data flow, navigation, and
  accessibility patterns before introducing custom behavior; deviations MUST be
  justified by a concrete product need.
- Apple Human Interface Guidelines are the default UX standard and MUST be
  treated as normative unless a documented constraint makes full adherence
  unreasonable.
- `FactoryKit` remains the default dependency wiring mechanism.
- `Testing`/`XCTest`, `Cuckoo`, and existing stub patterns remain the baseline
  testing toolchain.
- User-specific signing configuration MUST stay local, untracked, and out of
  logs, screenshots, and committed files.
- New third-party dependencies MUST include a clear need, maintenance owner, and
  removal strategy in the plan before adoption.

## Delivery Workflow & Quality Gates

Specs MUST describe independently testable user stories and capture operational
impact whenever a feature changes shared state, persistence, lifecycle behavior,
or telemetry. Plans MUST pass a documented constitution check before research
and again before task generation. Tasks MUST include the test work, observability
work, privacy/lifecycle validation, and HIG/platform-convention validation
needed by the affected stories rather than treating them as optional polish.

Changes MUST NOT be considered complete while linting or automated tests are
failing. Any exception to these principles MUST be documented in the relevant
`plan.md` complexity-tracking section with a concrete justification and a stated
rollback or cleanup path.

## Governance

This constitution overrides conflicting local habits and templates. Amendments
MUST be made in the same change set that updates any affected templates,
workflows, or guidance documents. Versioning follows semantic rules: MAJOR for
backward-incompatible governance changes or principle removals, MINOR for new
principles or materially expanded obligations, and PATCH for clarifications that
do not change enforcement expectations.

Every spec, plan, task list, and review that relies on Spec Kit MUST verify
compliance with this constitution. Runtime command guidance in `AGENTS.md` and
the repository or workspace runtime command guidance file remains authoritative
for how work is executed, while this constitution defines what quality bars
that work must satisfy.

**Version**: 1.1.1 | **Ratified**: 2026-06-03 | **Last Amended**: 2026-06-03
