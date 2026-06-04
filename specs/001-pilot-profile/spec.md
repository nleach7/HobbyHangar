# Feature Specification: Pilot Profile

**Feature Branch**: `001-pilot-profile`

**Created**: 2026-06-03

**Status**: Draft

**Input**: User description: "Pilot Profile with profile picture, pilot name, callsign, total flights, total flight time, total flight distance, flight locations (links to map), and most flown aircraft."

## Clarifications

### Session 2026-06-03

- Q: Which saved flight locations should contribute to the profile geographic heat map? → A: Only saved coordinate-backed flight locations contribute; flights without coordinates are excluded from the heat map.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Pilot Profile Identity (Priority: P1)

As a recreational UAV pilot, I want to open my pilot profile and see my profile picture, pilot name, and callsign so the logbook has a recognizable personal profile.

**Why this priority**: A readable profile identity is the foundation of the feature; without it, the profile cannot establish who the logbook represents.

**Independent Test**: Can be fully tested by opening the profile for a pilot with saved identity details and verifying that the visible profile picture, name, and callsign match the saved profile data.

**Acceptance Scenarios**:

1. **Given** a pilot has a saved profile picture, name, and callsign, **When** the pilot opens the profile, **Then** the profile shows the picture, name, and callsign in a prominent profile header.
2. **Given** a pilot has no saved profile picture, **When** the pilot opens the profile, **Then** the profile shows a non-identifying placeholder instead of a broken or stale image.
3. **Given** a pilot has not entered a callsign, **When** the pilot opens the profile, **Then** the missing callsign state is clear without blocking the profile.

---

### User Story 2 - Manage Pilot Identity (Priority: P2)

As a pilot, I want to add or update my profile picture, pilot name, and callsign so the profile reflects how I identify myself in the logbook.

**Why this priority**: A profile without editable identity fields is less personal and less useful, but the summary view can still provide value before editing is complete.

**Independent Test**: Can be tested by creating or editing profile identity values, saving them, leaving the profile, and confirming the same values appear after returning to the profile and after relaunching the app.

**Acceptance Scenarios**:

1. **Given** a pilot has not completed profile identity details, **When** the pilot adds a name, callsign, and profile picture, **Then** those values are saved and shown on the profile.
2. **Given** a pilot has existing identity details, **When** the pilot changes the name, callsign, or picture, **Then** the profile reflects the updated values without changing flight summary totals.
3. **Given** the pilot removes the profile picture, **When** the profile is displayed, **Then** a non-identifying placeholder is shown instead of a broken or stale image.

---

### User Story 3 - Display Logbook-Derived Flight Summary (Priority: P3)

As a pilot, I want my profile to display total flights, total flight time, total flight distance, flight locations, and most flown aircraft from my logbook so I can understand my flying history without manually entering summary values.

**Why this priority**: These summary values turn the profile from identity-only into a useful logbook overview while remaining a straightforward display of existing flight data.

**Independent Test**: Can be tested by using flight logs with known durations, distances, locations, and aircraft assignments, then verifying that each displayed profile summary value matches the logbook data.

**Acceptance Scenarios**:

1. **Given** a pilot has saved flight logs with durations, distances, locations, and aircraft assignments, **When** the pilot opens the profile, **Then** the profile displays total flights, total flight time, total flight distance, flight locations, and most flown aircraft derived from those logs.
2. **Given** a pilot has no saved flights, **When** the pilot opens the profile, **Then** the profile displays zero totals and clear empty states for flight locations and most flown aircraft.
3. **Given** some saved flights are missing distance or location information, **When** the pilot views the profile, **Then** totals and locations are calculated from available logbook data without requiring incomplete portions to be identified.
4. **Given** two or more aircraft are tied for greatest total saved flight time, **When** the pilot views the most flown aircraft section, **Then** the tied state is clear and the tied aircraft can be identified.

---

### User Story 4 - Open Most Flown Aircraft Record (Priority: P4)

As a pilot, I want to tap the most flown aircraft on my profile and view its preserved aircraft record so I can quickly inspect the aircraft behind the profile summary.

**Why this priority**: This adds useful navigation from a summary insight to the underlying aircraft record, including aircraft the pilot no longer actively keeps in the hangar.

**Independent Test**: Can be tested by using a logbook with a known most flown aircraft, selecting that aircraft from the profile, and verifying that the matching aircraft record is shown.

**Acceptance Scenarios**:

1. **Given** the profile displays one most flown aircraft, **When** the pilot taps that aircraft, **Then** the matching aircraft record is shown.
2. **Given** the profile displays multiple tied most flown aircraft, **When** the pilot taps one tied aircraft, **Then** the selected aircraft record is shown.
3. **Given** the most flown aircraft has been removed from the pilot's active hangar, **When** the pilot taps that aircraft, **Then** the preserved aircraft record is shown with its removed-from-hangar status clear.
4. **Given** saved flight logs reference an aircraft that has been removed from the active hangar, **When** the profile or logbook displays that aircraft, **Then** the aircraft record remains available instead of being treated as deleted or unavailable.

---

### User Story 5 - View Flight Location Geographic Heat Map (Priority: P5)

As a pilot, I want flight locations to appear as a geographic heat map on my profile so I can understand where I fly most often at a glance, then tap the map when I need a larger view.

**Why this priority**: Map exploration is valuable after the profile summary exists, and showing the heat map directly on the profile makes repeated flying areas visible without extra navigation.

**Independent Test**: Can be tested by using flight logs with known coordinates, opening the profile, verifying that the profile-screen map displays a standard geographic heat map using only coordinate-backed locations with all contributing points accommodated by default, then tapping the map and verifying that a full-screen map view opens.

**Acceptance Scenarios**:

1. **Given** the profile has saved flight locations with coordinates, **When** the pilot opens the profile, **Then** a geographic heat map appears on the profile screen for saved flight activity.
2. **Given** saved flights with coordinates are spread across different geographic areas, **When** the profile heat map is shown, **Then** the default zoom accommodates all coordinate-backed flight locations.
3. **Given** multiple saved flights have coordinate-backed locations, **When** the profile heat map is shown, **Then** areas with denser saved flight activity are represented with greater heat intensity using a projection suitable for 2D viewing.
4. **Given** the profile heat map is visible, **When** the pilot taps the map, **Then** the same geographic heat map opens in a full-screen map view.
5. **Given** no saved flight locations have coordinates, **When** the pilot views the profile, **Then** the heat-map area shows an empty state without presenting a broken map.

### Edge Cases

- A pilot has no profile picture, no callsign, or an unusually long name or callsign.
- A pilot has no saved flights, only deleted flights, or only incomplete flight records.
- Flight logs contain missing, invalid, duplicate, or densely clustered location information.
- Flight logs contain text-only locations without saved coordinates.
- Flight logs contain distance values in different display units or missing distance values.
- A profile-screen or full-screen map cannot be shown because the device is offline, all locations are incomplete, or map access is unavailable.
- Flight locations have limited precision or inconsistent naming.
- The most flown aircraft cannot be determined because no logged flight is associated with an aircraft.
- The most flown aircraft has been removed from the pilot's active hangar after the summary is calculated but must remain available as a preserved aircraft record.
- A profile edit fails to save or is interrupted while the app is backgrounded.
- Accessibility users rely on VoiceOver, larger text sizes, or reduced motion while viewing or editing the profile.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The profile MUST display the current pilot's profile picture, pilot name, and callsign in a prominent profile header.
- **FR-002**: The profile MUST allow the pilot to add, update, and remove the profile picture.
- **FR-003**: The profile MUST allow the pilot to add and update pilot name and callsign values.
- **FR-004**: The profile MUST require a pilot name before saving identity details; callsign and profile picture MUST remain optional, and the profile MUST present user-readable feedback when the required name is missing or values cannot be saved.
- **FR-005**: The profile MUST preserve saved identity details across app relaunches and offline use.
- **FR-006**: The profile MUST display total flights based on saved logbook flights that have not been deleted or otherwise excluded from the logbook.
- **FR-007**: The profile MUST display total flight time as the sum of saved flight durations in a human-readable format.
- **FR-008**: The profile MUST display total flight distance as the sum of saved flight distances in the app's current display units.
- **FR-009**: When one or more flights are missing distance data, the profile MUST calculate and display the distance total from available saved distance values without requiring a separate incomplete-data notice.
- **FR-010**: The profile MUST display flight locations derived from saved flight logs with valid coordinate-backed location information.
- **FR-011**: Coordinate-backed flight locations displayed on the profile MUST contribute to a standard geographic heat map of saved flight activity without applying a fixed distance grouping rule.
- **FR-012**: The profile screen MUST display the geographic heat map when at least one saved flight has coordinate-backed location data.
- **FR-013**: The profile-screen geographic heat map MUST default to a zoom level that accommodates all coordinate-backed flight locations.
- **FR-014**: Heat-map intensity MUST reflect the density of saved flights with coordinate-backed locations.
- **FR-015**: The geographic heat map MUST use a map projection suitable for 2D viewing.
- **FR-016**: The geographic heat map MUST reflect the geographic spread of saved flight locations rather than reducing locations to discrete pins or manually grouped areas.
- **FR-017**: The profile-screen geographic heat map MUST open into a full-screen map view when selected.
- **FR-018**: The full-screen map view MUST preserve the same geographic heat map data and provide a larger view of the profile-screen map.
- **FR-019**: Locations without coordinates MUST remain understandable in the profile without contributing to the heat map or presenting a broken map.
- **FR-020**: The profile MUST display the most flown aircraft using the aircraft associated with the greatest total saved flight time.
- **FR-021**: If multiple aircraft tie for greatest total saved flight time, the profile MUST make the tie clear and allow the pilot to identify the tied aircraft.
- **FR-022**: The profile MUST allow the pilot to select a displayed most flown aircraft and view the matching aircraft record, including records for aircraft removed from the active hangar.
- **FR-023**: Aircraft records referenced by saved flights MUST be preserved for profile and logbook history when the pilot removes the aircraft from the active hangar.
- **FR-024**: Flight summary totals, locations, heat map, and most flown aircraft MUST refresh when saved flights or aircraft associations change.
- **FR-025**: Summary totals MUST be derived from saved logbook data and MUST NOT be manually editable from the profile.
- **FR-026**: The profile MUST provide clear empty states for missing identity details, missing flights, missing locations, missing heat-map data, and missing aircraft usage.
- **FR-027**: The profile MUST support accessible labels, values, focus order, text scaling, and touch targets for identity fields, statistics, profile picture controls, profile-screen map, full-screen map, and aircraft usage content.
- **FR-028**: Profile diagnostics MUST record safe events for profile load, profile save, summary refresh, profile map display, full-screen map open, aircraft record selection, and recoverable failures.
- **FR-029**: Profile diagnostics MUST NOT include pilot name, callsign, profile image content, exact flight locations, aircraft names, or other personally identifying flight details.
- **FR-030**: The profile MUST recover gracefully from interrupted saves, unavailable map displays, and temporarily unavailable flight summary data without corrupting existing profile data.

### Key Entities

- **Pilot Profile**: Represents the current pilot's visible identity in the logbook, including required pilot name, optional callsign, and optional profile picture.
- **Flight Summary Metrics**: Represents derived profile statistics including total flights, total flight time, total flight distance, flight locations, and most flown aircraft.
- **Flight Location Summary**: Represents logged flight location data that can be displayed on the profile screen. Coordinate-backed locations contribute to a standard geographic heat map, while locations without coordinates do not.
- **Aircraft Usage Summary**: Represents total saved flight-time usage for aircraft associated with saved flights, including the most-flown result, any tied results, and the related preserved aircraft record.

## Operational Considerations *(mandatory when feature changes state, persistence, lifecycle, or telemetry)*

- **State Owner**: The app must maintain a single authoritative pilot profile record and derive all summary metrics from saved flight, aircraft, and location records rather than storing manually edited totals.
- **Lifecycle / Offline Behavior**: Saved profile identity and derived summary values must remain available from SwiftData-backed local storage while offline, after backgrounding, after relaunch, and after same-pilot iCloud sync makes profile and logbook data available on another device. Interrupted edits or sync updates must either complete safely or leave the previous saved profile intact.
- **Observability**: Diagnostic events must help identify profile load/save failures, summary refresh failures, unavailable profile or full-screen map displays, and aircraft-record navigation failures without exposing identity, image, location, or aircraft details.
- **Privacy / Data Sensitivity**: Pilot name, callsign, profile picture, flight locations, and aircraft usage are personal data. They must remain local-first, sync only through the pilot's iCloud account for cross-device continuity, and must not be shared outside that account except through explicit pilot action such as opening the full-screen map.
- **HIG / Platform Alignment**: The profile must follow native iOS navigation, editing, feedback, permission, accessibility, and content layout conventions. The profile-screen map must be understandable at profile scale, and any profile picture, aircraft record, or full-screen map interaction must provide clear user intent, recoverable cancellation, and understandable fallback states.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A returning pilot can open the profile and see identity details plus all available summary metrics within 2 seconds in at least 95% of validation runs using up to 1,000 saved flights.
- **SC-002**: A pilot can add or update name, callsign, and profile picture, save the changes, and verify the updated profile in under 2 minutes.
- **SC-003**: In validation scenarios covering no flights, missing distance, missing locations, tied aircraft, dense flight locations, and normal flight history, displayed totals, flight location heat-map inputs, and most-flown aircraft results match the source logbook data with 100% accuracy.
- **SC-004**: In profile validation scenarios, total flights, total flight time, total flight distance, and most flown aircraft are visible on the loaded profile without opening edit flows or secondary detail screens.
- **SC-005**: 100% of selected most flown aircraft entries present the matching aircraft record within 3 seconds during validation, including aircraft removed from the active hangar.
- **SC-006**: Profile loads with coordinate-backed flight locations show the profile-screen geographic heat map within 3 seconds in at least 95% of validation runs, with denser saved flight activity represented with greater intensity.
- **SC-007**: In validation scenarios with geographically spread coordinate-backed flight locations, the default profile-screen map zoom accommodates 100% of coordinate-backed flight locations.
- **SC-008**: 100% of profile-screen map selections open the full-screen map view within 3 seconds during validation while preserving the same heat-map data.
- **SC-009**: Accessibility validation finds no blocking issues for viewing the profile, editing identity details, understanding summary statistics, selecting most flown aircraft, viewing the profile-screen map, or opening the full-screen map with VoiceOver and large text sizes.

## Assumptions

- The profile is for the current pilot using the app; multi-pilot account switching is out of scope for this feature.
- Same-pilot cross-device sync through iCloud is in scope for the product and will be specified by the dedicated iCloud sync feature.
- Total flights count saved logbook flights that have not been deleted or explicitly excluded from the logbook.
- Total flight time and total flight distance are calculated from saved flight log values; missing distance values do not block the known distance total.
- Distance display units follow the app's existing unit preference or default; this feature does not introduce a separate unit preference.
- Flight locations with saved coordinates contribute directly to a standard geographic heat map; no fixed distance grouping rule is applied.
- Flight locations without saved coordinates are excluded from the heat map and are not resolved from text-only names for this feature.
- Heat-map intensity is based on the density of saved flights with coordinate-backed locations.
- The profile-screen map defaults to a zoom level that accommodates all coordinate-backed flight locations.
- The geographic heat map uses a projection suitable for 2D viewing.
- Tapping the profile-screen map opens a full-screen map view using the same heat-map data.
- Most flown aircraft is based on total saved flight time per associated aircraft; tied aircraft are treated as a meaningful tied result instead of selecting an arbitrary winner.
- Most flown aircraft navigation opens the aircraft's preserved record. Removing an aircraft from the active hangar means the pilot no longer has that aircraft, but the aircraft record is retained for profile and logbook history.
- Restoring an aircraft to the active hangar from the profile is out of scope.
- Map access is for viewing a geographic heat map of saved flight activity on the profile screen and in full-screen view, not for route planning, navigation guidance, or live tracking.
