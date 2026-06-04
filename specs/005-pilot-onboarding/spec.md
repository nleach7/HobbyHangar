# Feature Specification: Pilot Onboarding

**Feature Branch**: `005-pilot-onboarding`

**Created**: 2026-06-04

**Status**: Draft

**Input**: User description: "Onboarding: When the user launches the app for the first time and no existing data has been detected and synced from iCloud the user should be Welcomed to the app with a short description of what the app does. Then they should be walked through setting up their pilot profile, adding an aircraft, and adding a battery. At any point they should be allowed to skip the onboarding process."

## Clarifications

### Session 2026-06-04

- Q: What should the app do when the initial iCloud data check cannot confidently determine whether restored data exists? → A: Show a recovery choice letting the pilot either continue setup anyway or skip for now.
- Q: What should happen if iCloud data appears after onboarding-created records were already saved? → A: Prefer newly restored iCloud data and discard onboarding-created records after confirmation.
- Q: Should iCloud syncing be clarified across the existing feature specs or handled separately? → A: Create a dedicated iCloud sync feature spec covering pilot profile, aircraft, batteries, flights, and onboarding restore behavior.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start Brand-New Pilots Appropriately (Priority: P1)

As a first-time pilot with no existing local or iCloud-synced logbook data, I want the app to greet me and explain its purpose before setup begins, so I understand what Hobby Hangar helps me track.

**Why this priority**: Onboarding must appear only for truly new pilots and must not interrupt pilots whose data has already been restored or synced.

**Independent Test**: Can be tested by launching the app in scenarios with no saved data, existing local data, and existing iCloud-synced data, then verifying whether the welcome appears only in the no-data scenario.

**Acceptance Scenarios**:

1. **Given** a first app launch with no saved pilot profile, aircraft, battery, or flight data after the initial data check completes, **When** the app reaches the first usable screen, **Then** the pilot sees an onboarding welcome with a short description of the app.
2. **Given** a first app launch where existing data is restored or synced before the onboarding decision is made, **When** the app reaches the first usable screen, **Then** onboarding is not shown and the pilot enters the normal app experience.
3. **Given** the initial data check is still in progress, **When** the app is deciding whether to show onboarding, **Then** the app does not present the welcome until the presence or absence of existing data is known or a recovery choice is presented.
4. **Given** the initial data check is unavailable or inconclusive, **When** the app cannot confidently determine whether restored data exists, **Then** the pilot can choose either to continue setup anyway or skip onboarding for now.

---

### User Story 2 - Set Up Pilot Profile (Priority: P2)

As a brand-new pilot in onboarding, I want to create my pilot profile, so the logbook has my visible pilot identity before I begin tracking flights.

**Why this priority**: Pilot identity is the foundation for the app and is the first setup item the user was explicitly asked to complete.

**Independent Test**: Can be tested by starting onboarding, entering required pilot profile information, saving it, leaving and reopening the app, and confirming the profile remains available.

**Acceptance Scenarios**:

1. **Given** a brand-new pilot is on the pilot profile setup step, **When** the pilot enters valid required profile details and saves, **Then** the profile is saved and onboarding advances to aircraft setup.
2. **Given** a brand-new pilot is on the pilot profile setup step, **When** required profile information is missing, **Then** the pilot receives clear feedback and remains able to correct the entry, skip onboarding, or leave without losing previously saved setup progress.

---

### User Story 3 - Add First Aircraft (Priority: P3)

As a brand-new pilot in onboarding, I want to add an aircraft, so my Hangar has an active aircraft ready for future flight logs.

**Why this priority**: Flight logging depends on an aircraft record, and onboarding should help the pilot create the first usable fleet entry.

**Independent Test**: Can be tested by completing or bypassing profile setup, entering valid required aircraft information, saving it, and confirming the aircraft appears as an active Hangar aircraft after onboarding.

**Acceptance Scenarios**:

1. **Given** a brand-new pilot is on the aircraft setup step, **When** the pilot enters valid required aircraft details and saves, **Then** an active aircraft record is saved and onboarding advances to battery setup.
2. **Given** a brand-new pilot is on the aircraft setup step, **When** required aircraft information is missing, **Then** the pilot receives clear feedback and remains able to correct the entry, skip onboarding, or leave without losing previously saved setup progress.

---

### User Story 4 - Add First Battery (Priority: P4)

As a brand-new pilot in onboarding, I want to add a battery, so I have an active battery ready for future flight logs and battery tracking.

**Why this priority**: Battery tracking and flight logging both depend on at least one active battery, but the pilot can still get value from profile and aircraft setup if this step is skipped.

**Independent Test**: Can be tested by reaching the battery setup step, entering valid required battery information, saving it, and confirming the battery appears as an active Battery Tracker battery after onboarding.

**Acceptance Scenarios**:

1. **Given** a brand-new pilot is on the battery setup step, **When** the pilot enters valid required battery details and saves, **Then** an active battery record is saved and onboarding reaches its completion state.
2. **Given** a brand-new pilot is on the battery setup step, **When** required battery information is missing, **Then** the pilot receives clear feedback and remains able to correct the entry, skip onboarding, or leave without losing previously saved setup progress.

---

### User Story 5 - Skip Onboarding at Any Point (Priority: P5)

As a pilot who does not want guided setup, I want to skip onboarding from any onboarding step, so I can use the app immediately and add data later from the normal app areas.

**Why this priority**: The user explicitly requires skip availability at any point, and skip behavior must be predictable so onboarding does not become a blocker.

**Independent Test**: Can be tested by selecting skip from the welcome, pilot profile, aircraft, and battery steps, then verifying the pilot lands in the normal app experience and onboarding does not automatically return on relaunch.

**Acceptance Scenarios**:

1. **Given** the pilot is viewing any onboarding step, **When** the pilot chooses to skip onboarding, **Then** onboarding ends and the pilot enters the normal app experience.
2. **Given** the pilot skipped onboarding after saving one or more setup records, **When** the app is relaunched, **Then** saved records remain available and onboarding is not automatically shown again.
3. **Given** the pilot skipped onboarding without saving setup records, **When** the pilot later opens Pilot Profile, Hangar, or Battery Tracker, **Then** the pilot can create the same records through the normal app experience.

### Edge Cases

- Existing local data is present before iCloud has finished syncing.
- Existing iCloud-synced data appears during the onboarding eligibility decision.
- The initial iCloud data check is unavailable, delayed, or returns a recoverable failure.
- The pilot chooses to continue setup after an unavailable or inconclusive iCloud data check and existing data appears later.
- The pilot chooses to skip onboarding for now after an unavailable or inconclusive iCloud data check.
- Existing iCloud data appears after the pilot has saved onboarding-created profile, aircraft, or battery records.
- The app is closed, backgrounded, or terminated during an onboarding step.
- The pilot completes some setup steps and then skips the rest of onboarding.
- The pilot enters duplicate, incomplete, invalid, unusually long, or similar-looking profile, aircraft, or battery values.
- Saved setup data becomes temporarily unavailable while onboarding is active.
- Accessibility settings such as large text, VoiceOver, reduced motion, or increased contrast are enabled during onboarding.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST determine onboarding eligibility from the absence of saved pilot profile, aircraft, battery, and flight data after checking available local and iCloud-synced data.
- **FR-002**: The app MUST NOT present onboarding when any existing pilot profile, aircraft, battery, or flight data is detected locally or from iCloud before the onboarding decision is made.
- **FR-003**: Onboarding MUST treat iCloud-synced data availability, restore behavior, and cross-device conflict handling as dependencies of a separate iCloud sync feature that covers pilot profile, aircraft, batteries, and flights.
- **FR-004**: When onboarding eligibility is met, the app MUST present a welcome step that briefly describes Hobby Hangar as a recreational UAV pilot logbook for pilot profile, flight logging, fleet management, and battery tracking.
- **FR-005**: The welcome step MUST provide a clear primary action to begin setup and a clear option to skip onboarding.
- **FR-006**: Onboarding MUST guide the pilot through setup in this order: pilot profile, aircraft, battery.
- **FR-007**: Every onboarding step MUST provide a way to skip the rest of onboarding without requiring the pilot to complete or save the current step.
- **FR-008**: Skipping onboarding MUST take the pilot to the normal app experience without deleting any setup records already saved during onboarding.
- **FR-009**: After onboarding is completed or skipped, the app MUST remember that decision and MUST NOT automatically present onboarding again on later launches for the same app data set.
- **FR-010**: The pilot profile setup step MUST allow the pilot to create a pilot profile using the same required and optional identity information, validation, persistence, and feedback rules defined for Pilot Profile.
- **FR-011**: The aircraft setup step MUST allow the pilot to create an active aircraft record using the same required and optional aircraft information, validation, persistence, and feedback rules defined for the Hangar.
- **FR-012**: The battery setup step MUST allow the pilot to create an active battery record using the same required and optional battery information, validation, persistence, and feedback rules defined for Battery Tracker.
- **FR-013**: Onboarding MUST advance only after a setup step is saved successfully or after the pilot chooses to skip the rest of onboarding.
- **FR-014**: If saving a pilot profile, aircraft, or battery fails, onboarding MUST show clear, recoverable feedback and MUST preserve any setup records already saved.
- **FR-015**: If the app is backgrounded, terminated, or relaunched during onboarding, the app MUST preserve saved setup records and resume at the next incomplete onboarding step unless onboarding was completed or skipped.
- **FR-016**: If existing data is detected after onboarding has started but before the pilot saves new setup data, the app MUST stop guided setup and take the pilot to the normal app experience without creating duplicate records.
- **FR-017**: If existing iCloud data is detected after the pilot has saved onboarding-created records, the app MUST prefer the newly restored iCloud data and MUST discard onboarding-created records only after the pilot confirms that choice.
- **FR-018**: Onboarding MUST provide understandable loading, empty, and recovery states while the initial local and iCloud data check is unresolved or temporarily unavailable.
- **FR-019**: If the initial iCloud data check is unavailable or inconclusive, onboarding MUST present a recovery choice that lets the pilot continue setup anyway or skip onboarding for now.
- **FR-020**: Choosing to skip onboarding for now from the iCloud data-check recovery choice MUST enter the normal app experience for the current launch without marking onboarding completed or permanently skipped.
- **FR-021**: Choosing to continue setup anyway from the iCloud data-check recovery choice MUST allow onboarding to proceed while preserving the confirmed replacement path if existing iCloud data appears later.
- **FR-022**: Onboarding MUST support accessible labels, values, focus order, text scaling, contrast, reduced motion, and touch targets for the welcome, setup forms, validation feedback, progress, completion, data-check recovery, and skip controls.
- **FR-023**: Onboarding diagnostics MUST record safe events for eligibility check outcomes, welcome display, setup step entry, setup step completion, skip, completion, data-check recovery choices, and recoverable failures.
- **FR-024**: Onboarding diagnostics MUST NOT include pilot name, callsign, profile images, aircraft names, battery names, battery identifiers, hardware details, flight details, exact locations, or other pilot-specific payload values.
- **FR-025**: Onboarding MUST keep required actions and available exits visible and understandable without relying on external documentation.

### Key Entities *(include if feature involves data)*

- **Onboarding Eligibility**: Represents whether the app should show onboarding for the current app data set, based on the absence of saved local and iCloud-synced pilot, aircraft, battery, and flight data.
- **Onboarding Progress**: Represents the pilot's current position in the welcome, pilot profile, aircraft, and battery setup flow, including completed setup steps.
- **Onboarding Dismissal State**: Represents whether onboarding was completed or skipped so the app can avoid presenting it again automatically.
- **Pilot Profile**: Represents the current pilot's visible identity in the logbook, including required and optional identity details defined by Pilot Profile.
- **Aircraft**: Represents one active UAV or other remotely piloted aircraft in the pilot's Hangar.
- **Battery**: Represents one active physical battery pack available to the pilot in Battery Tracker.

## Operational Considerations *(mandatory when feature changes state, persistence, lifecycle, or telemetry)*

- **State Owner**: The onboarding experience owns eligibility, progress, completion, and dismissal state. Saved pilot profile, aircraft, and battery records remain owned by their respective product areas and must follow their existing data rules.
- **Lifecycle / Offline Behavior**: Onboarding waits for the initial local and iCloud data decision before presenting the welcome. The mechanics of syncing, restoring, and resolving iCloud data belong to the separate iCloud sync feature; onboarding consumes the resulting data availability decision. If that decision is unavailable or inconclusive, the pilot can continue setup anyway or skip onboarding for now. Saved setup records, completed steps, and permanent skip or completion decisions persist through backgrounding, relaunch, and offline use unless the pilot later confirms replacing onboarding-created records with newly restored iCloud data. Recoverable data-check or save failures keep the pilot in control and do not corrupt existing records.
- **Observability**: Diagnostics must make eligibility decisions, step transitions, completion, skip, and recoverable failures visible during validation while excluding user-entered profile, aircraft, battery, flight, and location values.
- **Privacy / Data Sensitivity**: Pilot identity, aircraft details, battery details, flight details, and exact location information are personal operational data and must not be exposed in diagnostics, screenshots intended for logs, or recovery messages.
- **HIG / Platform Alignment**: Onboarding follows Apple platform expectations for first-run experiences, progressive setup, clear navigation, non-destructive skip actions, visible validation feedback, accessibility, reduced motion, and graceful interruption handling. Any later plan deviation must be justified by a concrete product constraint.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of validation scenarios with no saved local or iCloud-synced pilot profile, aircraft, battery, or flight data, the onboarding welcome appears within 3 seconds after the initial data decision is resolved.
- **SC-002**: In 100% of validation scenarios with existing local or iCloud-synced pilot profile, aircraft, battery, or flight data, onboarding is bypassed and the pilot reaches the normal app experience.
- **SC-003**: A brand-new pilot can complete the welcome, pilot profile setup, aircraft setup, and battery setup in under 6 minutes during manual validation when valid required details are available.
- **SC-004**: In validation scenarios covering valid, missing, malformed, duplicate, and unusually long setup values, onboarding accepts or rejects pilot profile, aircraft, and battery entries according to their existing feature rules with 100% accuracy.
- **SC-005**: In 100% of validation scenarios, choosing skip from the welcome, pilot profile, aircraft, or battery step exits onboarding within 2 seconds and onboarding does not automatically reappear after app relaunch.
- **SC-006**: In 100% of validation scenarios where the app is backgrounded, terminated, or relaunched during onboarding, saved setup records remain available and the pilot resumes at the expected next incomplete step unless onboarding was completed or skipped.
- **SC-007**: In validation scenarios where existing data appears during the onboarding eligibility decision, onboarding is bypassed without creating duplicate pilot profile, aircraft, battery, or flight data in 100% of runs.
- **SC-008**: In 100% of validation scenarios where the initial iCloud data check is unavailable or inconclusive, the pilot can choose to continue setup anyway or skip onboarding for now without losing existing local records.
- **SC-009**: In 100% of validation scenarios where existing iCloud data appears after onboarding-created records were saved, the app keeps onboarding-created records until the pilot confirms replacement, then prefers the restored iCloud data and removes the onboarding-created records.
- **SC-010**: Accessibility validation finds no blocking issues for the welcome, setup steps, validation feedback, progress, completion, data-check recovery, confirmed replacement, or skip controls with VoiceOver, large text sizes, increased contrast, and reduced motion enabled.
- **SC-011**: Deterministic diagnostic review confirms that 100% of onboarding eligibility, step, completion, skip, data-check recovery choice, confirmed replacement, and recovery events omit pilot-entered profile, aircraft, battery, flight, and location payload values.

## Assumptions

- A pilot is considered brand-new when no pilot profile, aircraft, battery, or flight records exist locally or from the initial iCloud-synced data check.
- Any existing pilot profile, aircraft, battery, or flight record is enough to bypass first-run onboarding.
- A separate iCloud sync feature will define SwiftData-backed local storage, iCloud sync, restore, cross-device conflict handling, and privacy behavior for pilot profile, aircraft, battery, and flight data.
- Onboarding creates only the first pilot profile, first active aircraft, and first active battery; flight logging and advanced battery health entries remain outside this onboarding scope.
- The onboarding setup steps reuse the data rules already defined for Pilot Profile, the Hangar, and Battery Tracker.
- Skipping onboarding dismisses the guided flow rather than deleting saved data or blocking later setup through normal app areas.
- Skipping onboarding for now from the iCloud data-check recovery choice is temporary and distinct from the normal permanent skip action available within onboarding.
