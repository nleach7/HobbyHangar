# Feature Specification: The Hangar

**Feature Branch**: `002-hangar-fleet-management`

**Created**: 2026-06-04

**Status**: Draft

**Input**: User description: "The Hangar is the technical registry for a pilot's fleet. The pilot will create entries for each aircraft which can then be referenced in flights in the log book and stats on the pilot profile."

## Clarifications

### Session 2026-06-04

- Q: Should inactive aircraft be selectable when creating a new flight log? -> A: Inactive aircraft cannot be selected for new flight logs; the pilot must restore the aircraft first.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Create Aircraft Record (Priority: P1)

As a recreational UAV pilot, I want to add an aircraft to my Hangar with its identifying and technical details so that my fleet has an accurate registry entry.

**Why this priority**: The Hangar has no value until the pilot can create aircraft records. These records are the source for later flight logging and profile statistics.

**Independent Test**: Can be fully tested by creating a new aircraft with a required name and optional technical details, saving it, leaving the Hangar, returning, and verifying the same aircraft record is present.

**Acceptance Scenarios**:

1. **Given** the pilot has an empty Hangar, **When** the pilot creates an aircraft with a valid name, **Then** the aircraft appears in the active Hangar.
2. **Given** the pilot enters optional technical details for an aircraft, **When** the aircraft is saved, **Then** the saved record shows those details on the aircraft record.
3. **Given** the pilot attempts to save an aircraft without a name, **When** the save is submitted, **Then** the aircraft is not saved and the pilot receives clear feedback that the name is required.

---

### User Story 2 - Review and Maintain Fleet Records (Priority: P2)

As a pilot, I want to browse, favorite, inspect, and edit aircraft in my Hangar so that the technical registry stays current as my fleet changes and the aircraft I care about most are easy to reach.

**Why this priority**: Pilots need to trust the Hangar as the authoritative view of active aircraft before those aircraft can be reused across logbook and profile workflows.

**Independent Test**: Can be tested by creating multiple aircraft, favoriting selected aircraft, opening each aircraft record, editing identifying and technical details, and confirming the Hangar reflects the latest saved values and favorite status after relaunch.

**Acceptance Scenarios**:

1. **Given** the pilot has one or more active aircraft, **When** the pilot opens the Hangar, **Then** the active aircraft are visible with enough information to distinguish them.
2. **Given** an aircraft has saved technical details, **When** the pilot opens that aircraft record, **Then** the record shows the saved technical details in readable sections.
3. **Given** the pilot edits an aircraft's name, image, or technical details, **When** the changes are saved, **Then** the existing aircraft record is updated without creating a duplicate fleet entry.
4. **Given** the pilot marks an aircraft as a favorite, **When** the Hangar list is shown, **Then** the aircraft is denoted with a star and its favorite status persists after relaunch.

---

### User Story 3 - Sort the Hangar List (Priority: P3)

As a pilot, I want to sort aircraft in the Hangar so that I can quickly find favorite aircraft by default or compare the fleet by name, flight count, or flight time.

**Why this priority**: Sorting makes larger fleets usable and helps pilots move between everyday aircraft access and usage-based review without changing aircraft records.

**Independent Test**: Can be tested by creating aircraft with different names, favorite states, flight counts, and flight times, then verifying each sort option orders the same aircraft according to its defined rule.

**Acceptance Scenarios**:

1. **Given** the Hangar contains favorited and non-favorited aircraft with different names, **When** the default sort is active, **Then** favorited aircraft appear first sorted alphabetically by name, followed by the remaining aircraft sorted alphabetically by name.
2. **Given** the Hangar contains favorited and non-favorited aircraft, **When** the pilot chooses alphabetical sort, **Then** all active aircraft are sorted alphabetically by name without grouping favorites first.
3. **Given** the Hangar contains aircraft with different saved flight counts, **When** the pilot chooses flight count descending sort, **Then** all active aircraft are sorted by highest flight count first without grouping favorites first.
4. **Given** the Hangar contains aircraft with different saved total flight times, **When** the pilot chooses flight time descending sort, **Then** all active aircraft are sorted by greatest total flight time first without grouping favorites first.

---

### User Story 4 - Reference Aircraft From Flight Logs (Priority: P4)

As a pilot, I want flight logs to reference aircraft from my Hangar so that each flight is tied to the exact aircraft flown instead of relying on duplicated text.

**Why this priority**: Aircraft references are the link between Hangar records, flight history, and aircraft usage statistics on the pilot profile.

**Independent Test**: Can be tested by creating an aircraft, selecting it for a flight log, then confirming the flight shows the same aircraft record and remains linked after the aircraft details are edited.

**Acceptance Scenarios**:

1. **Given** the pilot has active aircraft in the Hangar, **When** the pilot records a flight, **Then** the pilot can choose an active aircraft from the Hangar.
2. **Given** a flight references a Hangar aircraft, **When** the aircraft record is edited, **Then** the flight continues to reference the same aircraft record.
3. **Given** profile statistics summarize aircraft usage, **When** saved flights reference Hangar aircraft, **Then** the profile can calculate aircraft usage from those references.

---

### User Story 5 - Preserve Aircraft History When Fleet Changes (Priority: P5)

As a pilot, I want to remove aircraft from my active Hangar without losing historical flight references so that sold, retired, or rebuilt aircraft still appear correctly in logbook history and profile stats.

**Why this priority**: Fleet membership changes over time, but logbook history must remain trustworthy and profile statistics must still explain past flights.

**Independent Test**: Can be tested by creating an aircraft, logging a flight with it, removing the aircraft from the active Hangar, and verifying the historical flight and profile aircraft usage still identify the preserved aircraft record.

**Acceptance Scenarios**:

1. **Given** an aircraft has been used in saved flights, **When** the pilot removes it from the active Hangar, **Then** the aircraft no longer appears as an active aircraft for new flights by default.
2. **Given** an aircraft has been removed from the active Hangar, **When** the pilot views a historical flight that used it, **Then** the flight still shows the preserved aircraft record.
3. **Given** an inactive aircraft contributes to profile aircraft statistics, **When** the pilot views profile aircraft usage, **Then** the aircraft can still be identified from its preserved record.
4. **Given** the pilot wants to use a removed aircraft again, **When** the pilot restores it to the active Hangar, **Then** it becomes available for new flight logs.
5. **Given** an aircraft is inactive, **When** the pilot creates a new flight log, **Then** the inactive aircraft cannot be selected until the pilot restores it to the active Hangar.

### Edge Cases

- The pilot has no aircraft in the Hangar.
- The pilot creates aircraft with the same or similar names.
- The pilot has multiple favorited aircraft, no favorited aircraft, or changes favorite status while a non-default sort is active.
- The pilot switches between default, alphabetical, flight count descending, and flight time descending sort options.
- Aircraft have tied names, tied flight counts, tied flight times, no saved flights, or incomplete historical flight data.
- The pilot enters very long names, image metadata, firmware values, or technical notes.
- An aircraft has no image and only the required name.
- An aircraft has partial technical details because the pilot does not know every component.
- The pilot selects a technical category that requires additional details, then leaves those details blank.
- An aircraft image cannot be loaded, saved, or displayed.
- An aircraft is edited after it has already been referenced by saved flights.
- An aircraft is removed from the active Hangar after it has already been referenced by saved flights.
- A flight references an aircraft that is inactive, missing optional fields, or has since been renamed.
- The app is backgrounded or relaunched while the pilot is creating, editing, removing, or restoring an aircraft.
- The pilot uses VoiceOver, larger text sizes, reduced motion, or other accessibility settings while browsing, editing, selecting, removing, or restoring aircraft.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Hangar MUST provide a fleet registry for the current pilot's aircraft.
- **FR-002**: The pilot MUST be able to create an aircraft record with a non-empty pilot-facing name.
- **FR-003**: The pilot MUST be able to save optional aircraft details including image, prop size or class, flight controller, electronic speed controller, video transmitter, motor configuration, receiver, and GPS module.
- **FR-004**: The system MUST validate that required aircraft information is present before saving and MUST present clear, recoverable feedback when a record cannot be saved.
- **FR-005**: The system MUST validate any required details that depend on a selected technical category before saving that category on the aircraft record.
- **FR-006**: Saved aircraft records MUST remain available after leaving the Hangar, app relaunch, and offline use.
- **FR-007**: The Hangar MUST show a clear empty state when the pilot has not created any active aircraft.
- **FR-008**: The Hangar MUST display active aircraft with enough visible information for the pilot to distinguish entries, including entries with duplicate or similar names.
- **FR-009**: The pilot MUST be able to open an aircraft record and review all saved identifying and technical details.
- **FR-010**: The pilot MUST be able to edit an existing aircraft record without creating a duplicate aircraft identity.
- **FR-011**: The pilot MUST be able to mark and unmark active aircraft as favorites.
- **FR-012**: Favorited aircraft MUST be denoted with a star wherever favorite status is shown in the Hangar list.
- **FR-013**: Favorite status MUST persist after leaving the Hangar, app relaunch, and offline use.
- **FR-014**: The default Hangar sort MUST place favorited active aircraft first, sorted alphabetically by aircraft name, followed by non-favorited active aircraft sorted alphabetically by aircraft name.
- **FR-015**: The Hangar MUST provide sort options for default, alphabetical, flight count descending, and flight time descending.
- **FR-016**: The alphabetical sort option MUST sort all active aircraft alphabetically by aircraft name without grouping favorites first.
- **FR-017**: The flight count descending sort option MUST sort all active aircraft by saved flight count from highest to lowest without grouping favorites first.
- **FR-018**: The flight time descending sort option MUST sort all active aircraft by saved total flight time from greatest to least without grouping favorites first.
- **FR-019**: Non-default sort options MUST ignore favorite status for ordering while still allowing favorite status to remain visible.
- **FR-020**: Sort options based on flight history MUST use saved flight references to calculate aircraft flight count and total flight time.
- **FR-021**: Sort ties MUST be resolved by aircraft name so the list remains predictable.
- **FR-022**: Aircraft edits MUST preserve the aircraft identity used by saved flight logs and profile aircraft statistics.
- **FR-023**: The pilot MUST be able to remove an aircraft from the active Hangar.
- **FR-024**: Removing an aircraft from the active Hangar MUST preserve the aircraft record when it is referenced by saved flights.
- **FR-025**: An inactive aircraft MUST remain viewable from historical flight references and profile aircraft usage contexts.
- **FR-026**: An inactive aircraft MUST NOT be selectable for new flight logs unless the pilot first restores it to the active Hangar.
- **FR-027**: The pilot MUST be able to restore an inactive aircraft to the active Hangar.
- **FR-028**: New flight logs MUST be able to reference active aircraft from the Hangar rather than storing aircraft names as unrelated text.
- **FR-029**: Saved flights MUST retain their aircraft references when the referenced aircraft is edited, removed from the active Hangar, or restored.
- **FR-030**: Pilot profile aircraft usage statistics MUST be able to identify aircraft from saved flight references, including inactive aircraft.
- **FR-031**: The system MUST prevent active fleet removal from corrupting existing flight history or profile aircraft statistics.
- **FR-032**: The system MUST provide clear confirmation before removing an active aircraft when the removal affects future flight selection.
- **FR-033**: The system MUST provide understandable fallback states for missing aircraft images, incomplete optional technical details, empty fleet lists, unavailable saved records, and unavailable flight history totals used for sorting.
- **FR-034**: Hangar diagnostics MUST record safe events for aircraft list load, aircraft create, aircraft update, aircraft favorite status change, aircraft sort change, aircraft removal, aircraft restore, aircraft selection for a flight, and recoverable failures.
- **FR-035**: Hangar diagnostics MUST NOT include aircraft names, images, firmware values, hardware identifiers, flight references, or other pilot-specific aircraft details.
- **FR-036**: The Hangar MUST support accessible labels, values, focus order, text scaling, and touch targets for fleet browsing, favorite controls, sort controls, aircraft detail review, aircraft editing, removal confirmation, restoration, and aircraft selection from flight logging.

### Key Entities

- **Aircraft**: Represents one UAV, quad, or other remotely piloted aircraft in the pilot's fleet. Key information includes required pilot-facing name and optional image, prop size or class, flight controller, electronic speed controller, video transmitter, motor configuration, receiver, and GPS module.
- **Aircraft Technical Configuration**: Represents optional component details that help identify and maintain an aircraft, including selected video transmitter system, selected receiver system, firmware details when required by the selected system, and one or more motor specifications when entered.
- **Aircraft Lifecycle Status**: Represents whether an aircraft is active in the Hangar or inactive while preserved for historical flight and profile references.
- **Aircraft Favorite Status**: Represents whether the pilot has marked an active aircraft as a favorite, shown with a star and used by the default Hangar sort.
- **Hangar Sort Option**: Represents the pilot's chosen ordering for the active aircraft list: default, alphabetical, flight count descending, or flight time descending.
- **Aircraft Reference**: Represents the durable link from a flight log or profile statistic back to the aircraft record used for that flight history.
- **Flight Log Entry**: Represents a saved flight that can reference one Hangar aircraft.
- **Pilot Profile Aircraft Usage**: Represents derived aircraft usage shown on the pilot profile based on saved flights that reference Hangar aircraft.

## Operational Considerations *(mandatory when feature changes state, persistence, lifecycle, or telemetry)*

- **State Owner**: The app must maintain one authoritative Hangar registry for the current pilot. Flight logs and profile aircraft statistics must consume aircraft references from that registry rather than owning separate aircraft copies. Favorite status and the active sort selection belong to the Hangar list experience.
- **Lifecycle / Offline Behavior**: Aircraft records, favorite status, sort selection, and active or inactive status must remain available from SwiftData-backed local storage offline, after backgrounding, after relaunch, and after same-pilot iCloud sync makes Hangar data available on another device. Interrupted create, edit, favorite, sort, remove, restore, or sync updates must either complete safely or leave the last saved Hangar state intact.
- **Observability**: Diagnostic events must help identify Hangar load failures, save failures, favorite status failures, sort failures, removal or restoration failures, and aircraft selection failures without exposing aircraft names, images, component details, firmware values, or flight history.
- **Privacy / Data Sensitivity**: Aircraft names, images, hardware configuration, firmware values, and flight usage relationships are pilot-specific data. They must remain local-first, sync only through the pilot's iCloud account for cross-device continuity, and must not be shared outside that account except through explicit pilot action.
- **HIG / Platform Alignment**: The Hangar must follow native iOS navigation, list, detail, edit, confirmation, feedback, favorite, sorting, and accessibility conventions. Removing an aircraft from the active Hangar is a meaningful state change and must use clear language, recoverable navigation, and confirmation behavior that avoids accidental history confusion.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A pilot can create a new aircraft with a required name and optional technical details in under 3 minutes during validation.
- **SC-002**: A returning pilot can open the Hangar and see active aircraft within 2 seconds in at least 95% of validation runs using up to 200 aircraft.
- **SC-003**: In validation scenarios covering required name, optional image, partial technical details, category-specific required details, duplicate names, and long text values, saved aircraft records persist with 100% accuracy after relaunch.
- **SC-004**: 100% of saved flights created with a Hangar aircraft continue to identify the same aircraft after the aircraft is edited.
- **SC-005**: 100% of saved flights and profile aircraft usage summaries continue to identify a referenced aircraft after it is removed from the active Hangar.
- **SC-006**: In validation scenarios, create, favorite, sort, find, open, edit, remove, and restore workflows can each be completed successfully from the Hangar without external setup.
- **SC-007**: In 100% of validation scenarios with active aircraft available, the intended aircraft can be selected for a new flight log in under 30 seconds.
- **SC-008**: Accessibility validation finds no blocking issues for browsing the Hangar, reviewing aircraft details, editing aircraft, confirming removal, restoring aircraft, or selecting an aircraft for a flight with VoiceOver and large text sizes.
- **SC-009**: In validation scenarios covering favorited aircraft, non-favorited aircraft, duplicate names, tied flight counts, tied flight times, and aircraft with no saved flights, the default, alphabetical, flight count descending, and flight time descending sort orders match their specified rules with 100% accuracy.
- **SC-010**: In validation scenarios with inactive aircraft, new flight log selection excludes inactive aircraft until restoration, and restored aircraft become selectable with 100% accuracy.

## Assumptions

- The Hangar is scoped to the current pilot using the app; multi-pilot fleet sharing is out of scope for this feature.
- Same-pilot cross-device sync through iCloud is in scope for the product and will be specified by the dedicated iCloud sync feature.
- Aircraft name is the only universally required aircraft field.
- Aircraft image and technical details are optional unless a selected technical category requires a supporting detail to be meaningful.
- Favorite status is an optional pilot-maintained marker for active aircraft and is displayed as a star.
- The default Hangar sort is favorite-aware alphabetical ordering: favorites alphabetically first, then all remaining active aircraft alphabetically.
- The alphabetical, flight count descending, and flight time descending sort options ignore favorite status for ordering, while favorite stars remain visible.
- Flight count and flight time sorts use aircraft usage derived from saved flight references; aircraft with no saved flights have zero usage for these sort options.
- Permanent deletion of aircraft records is out of scope for this feature. Removing an aircraft means marking it inactive so historical flight and profile references can remain intact.
- Active aircraft are the only choices for new flight logs. Inactive aircraft remain visible only where needed for history, profile usage, or explicit restoration, and must be restored before they can be selected for a new flight.
- Flight logging and pilot profile features may be planned or implemented separately; this feature defines the Hangar registry behavior and reference contract they rely on.
- Aircraft usage statistics on the pilot profile are derived from saved flight references and are not manually edited in the Hangar.
