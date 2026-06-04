# Feature Specification: iCloud Data Sync

**Feature Branch**: `006-icloud-data-sync`

**Created**: 2026-06-04

**Status**: Draft

**Input**: User description: "iCloud syncing: All data stored in the local datastore should be synced with iCloud enabling automatic backups and multi-device support."

## Clarifications

### Session 2026-06-04

- Q: When the device switches to a different iCloud account while local Hobby Hangar data already exists, what should the app do before syncing? → A: Automatically sync existing local data to the new iCloud account.
- Q: When there is no local data on first launch, how long should the app wait for iCloud-backed data before treating the restore check as delayed or inconclusive and showing the recovery choice? → A: Wait up to 10 seconds before showing the recovery choice.
- Q: If local app data is cleared while iCloud-backed Hobby Hangar data still exists, should that clear only the device copy or delete the backup everywhere? → A: Delete from iCloud and all devices too.
- Q: If the device switches to a different iCloud account and that account already has Hobby Hangar data, how should local data and existing iCloud data be combined? → A: Replace local data with the existing iCloud data.
- Q: Before clearing local Hobby Hangar data deletes the iCloud backup and all same-account device copies, what confirmation should be required? → A: Destructive confirmation plus typing a short confirmation phrase.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Back Up All Saved Pilot Data Automatically (Priority: P1)

As a recreational UAV pilot, I want every saved profile, fleet, battery, flight, and setup record to be backed up through my iCloud account automatically so that my logbook is protected without manual export or backup steps.

**Why this priority**: Automatic backup is the primary value of the feature and must cover all app-owned saved data before multi-device continuity can be trusted.

**Independent Test**: Can be tested by creating representative saved data across Pilot Profile, the Hangar, Battery Tracker, Flight Logging, and onboarding state while iCloud is available, then confirming the same data set can be restored from iCloud after the app is installed on a device with no local data and no pilot-confirmed app data clear has occurred.

**Acceptance Scenarios**:

1. **Given** the pilot is signed into iCloud and iCloud data storage is available, **When** the pilot creates or updates any saved app data, **Then** the app keeps the data available locally and makes the saved change eligible for automatic iCloud backup.
2. **Given** the pilot removes a saved record from the app after a clear confirmation, **When** iCloud synchronization completes, **Then** the removal is reflected on the pilot's other devices without removing unrelated historical records.
3. **Given** the pilot has saved profile, aircraft, battery, flight, onboarding, and preference data, **When** the app is installed or reinstalled on the same iCloud account without a prior pilot-confirmed app data clear, **Then** the backed-up data can be restored without requiring manual import.
4. **Given** iCloud is unavailable, disabled, or the pilot is not signed in, **When** the pilot saves app data, **Then** the data remains saved locally and the app makes clear that it is not currently backed up to iCloud.

---

### User Story 2 - Continue the Same Logbook Across Devices (Priority: P2)

As a pilot who uses more than one device, I want my same logbook to appear on each device signed into my iCloud account so that I can view or update my records wherever I have the app installed.

**Why this priority**: Multi-device continuity is explicitly required and depends on the complete backed-up data set being restored with relationships intact.

**Independent Test**: Can be tested with two devices or simulator profiles using the same iCloud account by saving records on one device, waiting for synchronization, and verifying the same records, states, and relationships appear on the second device.

**Acceptance Scenarios**:

1. **Given** Device A and Device B are signed into the same iCloud account and have iCloud available, **When** the pilot creates a profile, aircraft, battery, or flight on Device A, **Then** the record appears on Device B after synchronization completes.
2. **Given** the pilot edits an existing record on Device A, **When** synchronization completes, **Then** Device B shows the updated record rather than a duplicate.
3. **Given** a flight references an aircraft and battery, **When** that flight synchronizes to another device, **Then** the flight still identifies the same historical aircraft and battery used.
4. **Given** the pilot changes lifecycle state such as inactive aircraft, retired batteries, favorites, sort choices, onboarding dismissal, or saved preferences, **When** synchronization completes, **Then** the other device reflects the same user-visible state.

---

### User Story 3 - Keep Working Offline and Recover Safely (Priority: P3)

As a pilot who may be at the field without reliable connectivity, I want local-first editing to keep working when iCloud is unavailable so that I can record flights and maintenance without losing data.

**Why this priority**: The app already promises local-first persistence and must not make flight logging, fleet management, or battery tracking dependent on network availability.

**Independent Test**: Can be tested by disabling network access or iCloud availability, creating and editing records, relaunching the app, re-enabling iCloud, and confirming the offline changes remain local first and later synchronize.

**Acceptance Scenarios**:

1. **Given** iCloud is unavailable, **When** the pilot creates, edits, retires, restores, or removes supported saved data, **Then** the app completes the local action according to the existing feature rules and marks the change for later synchronization.
2. **Given** the pilot made local changes while iCloud was unavailable, **When** iCloud becomes available again, **Then** pending changes synchronize automatically without requiring the pilot to repeat the work.
3. **Given** the app is backgrounded, terminated, or relaunched while sync work is pending, **When** the app becomes active again, **Then** the last saved local state remains intact and synchronization resumes when possible.
4. **Given** synchronization cannot complete because of a recoverable iCloud issue, **When** the pilot continues using the app, **Then** the app preserves local data and provides a nonblocking recovery state.

---

### User Story 4 - Resolve Cross-Device Data Differences Without Silent Loss (Priority: P4)

As a pilot editing from more than one device, I want the app to protect my records when changes happen before synchronization finishes so that aircraft, battery, and flight history are not silently lost or corrupted.

**Why this priority**: Automatic sync introduces new data-integrity risks, especially for linked flight history and records edited on multiple devices.

**Independent Test**: Can be tested by making different changes to the same record and related records on two devices before synchronization, then verifying that the app reaches a coherent final state and asks the pilot to choose only when a safe automatic result is not possible.

**Acceptance Scenarios**:

1. **Given** two devices create different new records while offline, **When** synchronization completes, **Then** both records are preserved and no unrelated records are overwritten.
2. **Given** two devices edit different fields of the same record before synchronization, **When** synchronization completes, **Then** the final record preserves all non-conflicting edits where possible.
3. **Given** two devices make incompatible edits to the same user-entered value before synchronization, **When** the app cannot determine a safe result, **Then** the pilot is shown a clear recovery choice before one value is discarded.
4. **Given** one device removes a record while another edits or references it before synchronization, **When** the app resolves the difference, **Then** historical flight references and other dependent records are preserved unless the pilot explicitly confirms a destructive outcome.

---

### User Story 5 - Restore-Aware First Launch and Sync Status (Priority: P5)

As a returning pilot installing the app on a new or reset device, I want the app to check for restored iCloud data before treating me as brand-new so that onboarding does not create duplicate records.

**Why this priority**: The onboarding feature depends on sync-aware restore behavior and must avoid confusing returning pilots with first-run setup when their data exists in iCloud.

**Independent Test**: Can be tested by launching the app with no local data under scenarios where iCloud data exists, where no iCloud data exists, and where the iCloud data check is unavailable or inconclusive.

**Acceptance Scenarios**:

1. **Given** no local app data exists and iCloud contains backed-up Hobby Hangar data for the pilot, **When** the app launches, **Then** the app restores or detects that data before deciding to present first-run onboarding.
2. **Given** no local or iCloud-backed app data exists after the initial data decision completes, **When** the app launches, **Then** onboarding may treat the pilot as brand-new according to the onboarding specification.
3. **Given** the initial iCloud data check is unavailable, delayed, or inconclusive, **When** the app cannot confidently decide whether restored data exists, **Then** the pilot receives a clear recovery choice rather than duplicate data being created automatically.
4. **Given** iCloud sync is pending, unavailable, failed, or in conflict, **When** the pilot views affected app areas, **Then** the app presents understandable status and recovery feedback without blocking unrelated local work.

### Edge Cases

- The pilot is not signed into iCloud.
- iCloud is disabled for the app at the account or device level.
- The device switches to a different iCloud account while local Hobby Hangar data already exists.
- The device switches to a different iCloud account that already has Hobby Hangar data.
- iCloud storage is full or temporarily unavailable.
- Network connectivity is unavailable, intermittent, slow, or restored while the app is in the background.
- The pilot installs the app on a new device with no local data but existing iCloud-backed data.
- The pilot reinstalls the app on the same device after local data was removed without a pilot-confirmed app data clear.
- Existing local data is present before iCloud finishes checking for restored data.
- Existing iCloud data appears after onboarding-created records have already been saved.
- The pilot creates, edits, retires, restores, favorites, sorts, or removes records on two devices before either device has synchronized.
- A flight synchronizes before its referenced aircraft or battery appears locally on the receiving device.
- A referenced aircraft is inactive, renamed, edited, restored, or missing from active selection when synced flight history appears.
- A referenced battery is retired, renamed, edited, restored, or missing from active selection when synced flight history appears.
- Large profile images, aircraft images, GPS tracks, telemetry series, battery health histories, or long flight histories are included in the synced data set.
- A previous app version created records that later need to participate in iCloud sync.
- The app is backgrounded, terminated, relaunched, or updated while synchronization, restore, conflict recovery, or onboarding eligibility checks are in progress.
- The pilot clears app data locally while iCloud-backed records still exist.
- The pilot starts clearing app data but cancels, dismisses the confirmation, or enters the wrong confirmation phrase.
- Sync diagnostics are reviewed for failures without exposing pilot-specific payload values.
- The pilot uses VoiceOver, larger text sizes, increased contrast, reduced motion, or other accessibility settings while reviewing sync status or resolving recovery choices.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST include every app-owned saved data category in the iCloud-backed data set, including pilot profile data, profile images, aircraft records, aircraft images, aircraft technical details, aircraft lifecycle state, aircraft favorite state, Hangar sort preferences, battery records, battery health entries, battery lifecycle state, flight records, manual flight details, flight locations, imported GPS tracks, imported telemetry series, saved source status, onboarding progress, onboarding dismissal state, and other saved preferences needed to recreate the pilot's app experience.
- **FR-002**: Derived profile, aircraft, and battery summaries MUST remain consistent after synchronization by deriving from the current saved profile, aircraft, battery, and flight records.
- **FR-003**: The app MUST use the pilot's iCloud account as the automatic backup and same-pilot multi-device continuity boundary.
- **FR-004**: The app MUST NOT require manual export, manual import, or a separate Hobby Hangar account for iCloud-backed automatic backup or same-pilot multi-device continuity.
- **FR-005**: The app MUST keep supported saved data available locally while offline or while iCloud is unavailable.
- **FR-006**: The app MUST make new local saves, edits, confirmed removals, lifecycle changes, onboarding decisions, and saved preference changes eligible for automatic iCloud synchronization.
- **FR-007**: Confirmed removals of records that the pilot deletes from the app MUST synchronize to the pilot's other devices without deleting unrelated records or historical references that are still required by existing feature rules.
- **FR-008**: Synchronization MUST preserve relationships between flights, aircraft, batteries, profile summaries, battery usage summaries, and aircraft usage summaries.
- **FR-009**: A synced flight MUST continue to identify its historical aircraft and battery when those records are inactive, retired, renamed, edited, restored, or unavailable for new-flight selection.
- **FR-010**: The app MUST restore iCloud-backed data on a new, reset, or reinstalled device signed into the same iCloud account before treating the pilot as having no existing data.
- **FR-011**: The app MUST provide onboarding with a data-availability decision that distinguishes restored iCloud-backed data, no known data, and inconclusive or unavailable iCloud checks.
- **FR-011a**: When no local data exists on first launch, the app MUST wait up to 10 seconds for iCloud-backed data before treating the restore check as delayed or inconclusive and showing the onboarding recovery choice.
- **FR-012**: If iCloud data appears after onboarding-created records have been saved, the app MUST keep existing records safe and require pilot confirmation before discarding onboarding-created records in favor of restored data.
- **FR-013**: The app MUST allow the pilot to continue local work when iCloud is unavailable, delayed, full, disabled, or not signed in.
- **FR-014**: Pending local changes MUST retry automatically when iCloud becomes available again.
- **FR-015**: The app MUST preserve the last saved local state through backgrounding, termination, relaunch, and recoverable synchronization failures.
- **FR-016**: The app MUST avoid creating duplicate records when the same saved record is restored or synchronized more than once.
- **FR-017**: The app MUST preserve distinct new records created on separate devices before synchronization.
- **FR-018**: For non-conflicting edits to the same saved record from different devices, the app MUST preserve all compatible user-entered changes where possible.
- **FR-019**: For incompatible cross-device edits that cannot be safely combined, the app MUST provide a clear recovery choice before discarding one user-entered value.
- **FR-020**: Cross-device removal or edit conflicts MUST protect historical flight references and other dependent records unless the pilot explicitly confirms a destructive outcome.
- **FR-021**: The app MUST show understandable sync status or recovery feedback when iCloud is unavailable, sync is pending, restore is in progress, a retry is needed, or pilot action is required.
- **FR-022**: Sync status and recovery feedback MUST be nonblocking for unrelated local work whenever the affected data can still be used safely.
- **FR-023**: The app MUST provide clear fallback states when iCloud backup is unavailable so pilots can distinguish locally saved data from backed-up data.
- **FR-024**: Original EdgeTX import files MUST remain transient import inputs and MUST NOT be synchronized or retained unless a separate future requirement explicitly adds original file retention.
- **FR-025**: Sync diagnostics MUST record safe events for sync availability, initial restore checks, backup eligibility, successful synchronization, pending retries, restore completion, conflict detection, conflict recovery, onboarding data decisions, and recoverable failures.
- **FR-026**: Sync diagnostics MUST NOT include pilot names, callsigns, profile images, aircraft names, aircraft images, hardware details, battery identifiers, IR readings, measured capacity values, condition observations, flight start date/times, durations, voltage values, mAh values, exact locations, GPS coordinates, telemetry samples, imported file contents, or other pilot-specific payload values.
- **FR-027**: The app MUST treat pilot profile details, aircraft details, battery details, flight details, location data, images, telemetry, and health histories as pilot-specific private data that syncs only through the pilot's iCloud account unless the pilot explicitly exports or shares it through another feature.
- **FR-028**: The app MUST support accessible labels, values, focus order, text scaling, contrast, reduced motion, and touch targets for sync status, restore progress, recovery choices, and conflict resolution.
- **FR-029**: The app MUST keep sync and restore messaging understandable without requiring the pilot to know technical storage, database, or cloud service details.
- **FR-030**: If the device switches to a different iCloud account while local Hobby Hangar data already exists and the current iCloud account has no existing Hobby Hangar data, the app MUST keep the local data available and automatically make that data eligible for backup and continuity in the current iCloud account.
- **FR-031**: If the pilot clears local Hobby Hangar app data while iCloud-backed data exists, the app MUST treat the clear as a global deletion that removes the iCloud-backed data and synchronizes the deletion to all devices on the same iCloud account only after the pilot completes a destructive confirmation and types the required short confirmation phrase.
- **FR-032**: If the device switches to a different iCloud account that already has Hobby Hangar data, the app MUST replace the device's local Hobby Hangar data with the existing data from the current iCloud account rather than merging the two data sets.
- **FR-033**: If the pilot cancels, dismisses, or fails the required confirmation phrase for clearing app data, the app MUST keep local and iCloud-backed Hobby Hangar data unchanged.

### Key Entities *(include if feature involves data)*

- **iCloud-Backed Data Set**: Represents all app-owned saved records and preferences that must be backed up and restored for the pilot's app experience, including profile, Hangar, Battery Tracker, Flight Logging, onboarding, and saved preference data.
- **Pilot Account Context**: Represents the current iCloud account boundary used to determine which devices belong to the same pilot backup and continuity experience, including whether a newly selected iCloud account already has Hobby Hangar data.
- **Sync Availability State**: Represents whether iCloud backup and synchronization are currently available, unavailable, pending, restoring, failed, or waiting for pilot action.
- **Pending Local Change**: Represents a saved local create, edit, removal, lifecycle change, onboarding decision, preference change, or pilot-confirmed app data clear that must synchronize when possible.
- **Restored Data Decision**: Represents the first-launch decision that tells onboarding whether restored data exists, no data exists, or iCloud data availability cannot yet be determined.
- **Sync Conflict**: Represents incompatible cross-device changes to the same saved record or dependent relationship that require safe automatic resolution or a pilot recovery choice.
- **Historical Reference**: Represents a durable relationship from a saved flight or summary back to the aircraft or battery used, even when that record is inactive, retired, renamed, edited, or restored.
- **Sync Diagnostic Event**: Represents safe observability metadata about sync and restore behavior while excluding pilot-specific payload values.

## Operational Considerations *(mandatory when feature changes state, persistence, lifecycle, or telemetry)*

- **State Owner**: The app must maintain one authoritative local data set for the current pilot. Product areas continue to own their records and validation rules, while the sync experience owns global sync availability, restore decisions, pending-change state, conflict recovery state, and user-visible sync feedback. Derived summaries remain owned by the product areas that present them and must be refreshed from synchronized base records.
- **Lifecycle / Offline Behavior**: Saved data remains local-first and usable offline. Creates, edits, confirmed removals, lifecycle changes, onboarding decisions, and saved preference changes made while iCloud is unavailable must persist locally, survive backgrounding and relaunch, and retry automatically when iCloud becomes available. Restore and onboarding decisions must avoid duplicate setup data by waiting for a resolved, unavailable, or inconclusive data decision before first-run onboarding proceeds.
- **Observability**: Diagnostics must make synchronization availability, initial restore checks, pending retries, successful sync, conflict detection, conflict recovery, onboarding data decisions, and recoverable failures visible during validation without logging pilot-specific payload values, exact locations, media contents, telemetry samples, imported files, or record names.
- **Privacy / Data Sensitivity**: Pilot identity, profile images, aircraft images, aircraft configurations, battery identifiers, health readings, flight history, locations, GPS tracks, telemetry, and onboarding state are pilot-specific private data. They must remain local-first, sync only through the pilot's iCloud account for backup and continuity, and must not be shared outside that account except through explicit pilot action in a separate feature.
- **HIG / Platform Alignment**: Sync status, restore progress, iCloud-unavailable states, and conflict recovery must follow native iOS expectations for account-dependent features, nonblocking status feedback, recoverable errors, clear confirmations before destructive actions, and accessibility. Any implementation plan deviation from standard platform conventions must be justified by a concrete product constraint.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In validation with a representative data set containing at least one pilot profile, one profile image, five aircraft, one aircraft image, five batteries, two battery health entries, five flights, one flight location, one GPS track, one telemetry series, onboarding dismissal state, and saved list preferences, 100% of expected records and relationships restore on a clean device signed into the same iCloud account.
- **SC-002**: In connected two-device validation runs, new profile, aircraft, battery, flight, onboarding, and saved preference changes made on Device A appear on Device B within 2 minutes of synchronization availability in at least 95% of runs.
- **SC-003**: In validation scenarios covering local create, edit, lifecycle change, confirmed removal, and saved preference change while iCloud is unavailable, 100% of changes remain available after relaunch and synchronize after iCloud availability returns.
- **SC-004**: In validation scenarios covering synced flights whose aircraft or batteries are active, inactive, retired, renamed, edited, or restored, 100% of flights continue to identify the historical aircraft and battery used.
- **SC-005**: In validation scenarios with two devices creating distinct new records before synchronization, 100% of distinct records are preserved after synchronization completes.
- **SC-006**: In validation scenarios with compatible and incompatible edits to the same record from two devices, compatible edits are preserved and incompatible edits show the specified recovery choice in 100% of cases.
- **SC-007**: In 100% of first-launch validation scenarios with no local data, existing iCloud-backed data, and no prior pilot-confirmed app data clear, the app restores or detects the existing data before presenting brand-new onboarding.
- **SC-008**: In 100% of first-launch validation scenarios where no local data exists and iCloud data availability remains unavailable or inconclusive for 10 seconds, the pilot receives a recovery choice and no duplicate onboarding-created records are created automatically.
- **SC-009**: In validation with a larger data set containing 25 aircraft, 50 batteries, 500 flights, 100 battery health entries, and 10,000 telemetry samples, restore completes with 100% relationship integrity and the app remains usable for local browsing while synchronization status is pending.
- **SC-010**: Accessibility validation finds no blocking issues for sync status, restore progress, iCloud-unavailable recovery, and conflict resolution with VoiceOver, large text sizes, increased contrast, and reduced motion enabled.
- **SC-011**: Deterministic diagnostic review confirms that 100% of sync availability, restore, retry, conflict, recovery, and onboarding data-decision events omit pilot-entered profile, aircraft, battery, flight, location, media, telemetry, and imported file payload values.
- **SC-012**: In 100% of validation scenarios where the device switches to a different iCloud account while local Hobby Hangar data exists and the current iCloud account has no existing Hobby Hangar data, the local data remains available and becomes eligible for backup and continuity in the current iCloud account.
- **SC-013**: In 100% of validation scenarios where the pilot clears local Hobby Hangar app data while iCloud-backed data exists, the data is removed from iCloud and all same-account devices only after the pilot completes the destructive confirmation and enters the required short confirmation phrase.
- **SC-014**: In 100% of validation scenarios where the device switches to a different iCloud account that already has Hobby Hangar data, the device replaces its local Hobby Hangar data with the current iCloud account's existing data instead of merging the two data sets.
- **SC-015**: In 100% of validation scenarios where the pilot cancels, dismisses, or enters the wrong confirmation phrase while clearing app data, local and iCloud-backed Hobby Hangar data remains unchanged.

## Assumptions

- The pilot's iCloud account is the intended trust and continuity boundary for automatic backups and multi-device support.
- Switching the device to a different iCloud account is treated as pilot intent to use the current iCloud account for automatic backup and continuity. If the current iCloud account already has Hobby Hangar data, that iCloud data replaces the device's local Hobby Hangar data; otherwise existing local data becomes eligible for backup and continuity in the current iCloud account.
- A first-launch restore check that cannot determine iCloud-backed data availability within 10 seconds is considered delayed or inconclusive for onboarding recovery purposes.
- Clearing local Hobby Hangar app data is treated as pilot intent to delete the synced data set from iCloud and all same-account devices only after a destructive confirmation and required short confirmation phrase are completed.
- When iCloud is unavailable or disabled, the app remains local-first and does not block normal profile, Hangar, Battery Tracker, Flight Logging, or onboarding work that can be completed locally.
- "All saved data" means all app-owned persisted records and preferences needed to recreate the pilot's app experience, excluding transient import inputs and temporary drafts that existing feature specs say are not retained.
- Derived summaries may be recalculated from synchronized base records as long as the user-visible results match across devices after synchronization.
- Sync status and recovery feedback should be visible only where it helps the pilot understand backup, restore, pending, unavailable, or conflict states; routine successful sync does not need to interrupt normal workflows.
- iCloud account setup, iCloud storage quotas, and device-level iCloud settings remain controlled by the operating system; the app explains the resulting availability state and recovery path.
