# Feature Specification: Flight Logging

**Feature Branch**: `004-flight-logging`

**Created**: 2026-06-04

**Status**: Draft

**Input**: User description: "Logbook: Flight Logging when the user logs a flight they will be asked which aircraft was flown, which battery was used, the date of the flight (defaults to today), flight duration, voltage (start/end), and mAh used. Alternatively the user may upload EdgeTX logs to record all of the above information and more including GPS tracks and telemetry graphs (RSSI, LQ, etc). Additional proposed data model: Flight records the aircraft flown and battery used as required references, and flight history must remain preserved if referenced aircraft or battery records later leave active inventory. If the user is manually entering the flight log, they should be asked, but not required, to provide a flight location on a map. The map should default to the user's current location. If location services are not provided, the user should be presented with a link to the system setting to enable them. When a GPS track is provided, the flight location should be set to the first GPS position saved after the aircraft started flying, using armed flags if available or throttle greater than zero for the first time if armed flags are not available. If a GPS track is available, the user should be able to view the track on a map. When available, data like mAh used, pack voltage, RSSI, and LQ should all be viewable on a line graph where Y is the data and X is the time in the flight it occurred."

## Clarifications

### Session 2026-06-04

- Q: How should EdgeTX imports split logs into flight sessions? → A: One log file initially creates one flight unless the pilot manually splits it during import review.
- Q: What EdgeTX import file format is required for this feature? → A: EdgeTX CSV telemetry logs with a header row.
- Q: When should the Logbook warn about duplicate or conflicting flight entries? → A: Warn when a new or edited flight occurs at the same or overlapping date/time range as an existing saved flight.
- Q: What should happen after a flight time overlap warning appears? → A: Show a nonblocking warning and allow the pilot to either save anyway or review/edit the flight details.
- Q: Should saved imported flights retain the original EdgeTX CSV file? → A: Do not retain the original CSV after saving; keep only parsed flight data.
- Q: Which source should Flight Logging use to create saved flight distance values for Pilot Profile totals? → A: Manual flights may save optional pilot-entered distance; imported GPS tracks can derive saved flight distance.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Log a Flight Manually (Priority: P1)

As a recreational UAV pilot, I want to manually record a completed flight with the aircraft, battery, start date/time, duration, location, distance, voltage, and mAh details I know so that my logbook captures useful flight history even when I do not have a radio log file.

**Why this priority**: Manual entry is the core logbook workflow and must work for every pilot before imported telemetry can add extra value.

**Independent Test**: Can be fully tested by creating active aircraft and battery records, starting a new flight log, confirming the start date/time defaults to the current local date/time, choosing the aircraft and battery as required references, entering a duration, reviewing the optional map location prompt, accepting or changing the default current-location map position when available, entering optional flight distance and available battery details, saving, leaving the Logbook, returning, and verifying the same flight entry is present with the same aircraft, battery, time range, optional distance, and optional location relationships.

**Acceptance Scenarios**:

1. **Given** the pilot has at least one active aircraft and one active battery, **When** the pilot starts a new manual flight log, **Then** the log entry asks for the aircraft flown, battery used, flight start date/time, flight duration, optional flight location on a map, optional flight distance, starting voltage, ending voltage, and mAh used.
2. **Given** the pilot starts a new manual flight log, **When** the entry form appears, **Then** the flight start date/time defaults to the current local date/time and can be changed to another valid past or current date/time.
3. **Given** current location is available for manual entry, **When** the optional flight location map is shown, **Then** the map defaults to the user's current location and the pilot can keep it, move it, clear it, or skip location entry.
4. **Given** current location is unavailable or the pilot does not provide a location, **When** the pilot saves the flight with all required fields present, **Then** the flight is saved without a location and the missing location is clearly marked as not recorded.
5. **Given** current location cannot be used because location services or location permission are not enabled, **When** the optional flight location map is shown, **Then** the pilot is offered a link to the appropriate system setting to enable location access without blocking manual location selection or saving.
6. **Given** the pilot provides an active aircraft, active battery, valid start date/time, and positive flight duration, **When** the pilot saves the flight with distance, voltage, or mAh fields left unknown, **Then** the flight is saved and the unknown values remain clearly marked as not recorded.
7. **Given** the pilot enters invalid duration, distance, voltage, or mAh values, **When** the pilot attempts to save, **Then** the flight is not saved and the pilot receives clear, recoverable feedback identifying the invalid fields.
8. **Given** a saved flight references an aircraft and battery, **When** the aircraft or battery later leaves active inventory, **Then** the saved flight still preserves the historical aircraft and battery used.
9. **Given** a manual flight's time range overlaps an existing saved flight, **When** the pilot attempts to save, **Then** the Logbook shows a nonblocking overlap warning and lets the pilot either save anyway or review and edit the flight details.
10. **Given** the pilot provides a valid optional distance for a manual flight, **When** the flight is persisted, **Then** the saved flight retains that distance for flight detail review and Pilot Profile total-distance calculations.

---

### User Story 2 - Import an EdgeTX Log (Priority: P2)

As a pilot with an EdgeTX radio log, I want to upload the log and review the extracted flight details before saving so that the Logbook captures telemetry, GPS, and battery usage without requiring duplicate manual entry.

**Why this priority**: Importing EdgeTX logs turns recorded radio telemetry into richer flight records and reduces manual transcription errors.

**Independent Test**: Can be tested by importing an EdgeTX log that includes timestamped telemetry, GPS points, flight-start indicators, voltage, mAh, RSSI, and LQ values, reviewing the created draft, choosing any missing aircraft or battery reference, saving the flight, and verifying the saved entry contains the extracted details, linked references, GPS track, derived flight location, and derived flight distance when enough valid GPS points are available.

**Acceptance Scenarios**:

1. **Given** the pilot selects an EdgeTX log containing one completed flight, **When** the import finishes, **Then** the Logbook shows a review draft populated with every recognized flight detail from the file.
2. **Given** the imported log does not identify a saved aircraft or battery with confidence, **When** the review draft is shown, **Then** the pilot must choose the active aircraft and active battery before saving.
3. **Given** the imported log may contain multiple flight sessions, **When** the import review draft is created, **Then** the log is initially treated as one flight candidate and the pilot can manually split it before saving.
4. **Given** the imported log or manually split segment includes GPS points and armed flags, **When** the import draft is created, **Then** the flight location is set to the first valid GPS position recorded after the aircraft first became armed for that flight candidate.
5. **Given** the imported log or manually split segment includes GPS points but no armed flags, **When** the import draft is created, **Then** the flight location is set to the first valid GPS position recorded after throttle first became greater than zero for that flight candidate.
6. **Given** the imported log is unsupported, malformed, empty, or missing usable flight data, **When** the import is attempted, **Then** no flight is saved and the pilot receives clear feedback explaining that the log could not be imported.
7. **Given** an imported flight candidate's time range overlaps an existing saved flight, **When** the pilot attempts to save the candidate, **Then** the Logbook shows a nonblocking overlap warning and lets the pilot either save anyway or review and edit the candidate.
8. **Given** the pilot saves an imported flight, **When** the saved flight is persisted, **Then** the saved flight retains parsed flight details, GPS tracks, and telemetry series without retaining the original EdgeTX CSV file contents.
9. **Given** an imported flight candidate includes enough valid ordered GPS points, **When** the import review draft is created, **Then** the draft includes a derived flight distance from the GPS track.

---

### User Story 3 - Review Flight Details, Tracks, and Telemetry (Priority: P3)

As a pilot, I want to review saved flights with their aircraft, battery, battery usage, GPS track on a map, and telemetry line graphs so that I can understand what happened during a flight and compare flights later.

**Why this priority**: A logbook must make saved records useful after entry; imported tracks and telemetry are valuable only if pilots can inspect them clearly.

**Independent Test**: Can be tested by saving one manual flight and one imported EdgeTX flight with GPS track, mAh used, pack voltage, RSSI, and LQ telemetry data, opening each flight detail, and verifying that manual values, imported values, derived flight distance when available, GPS track map, telemetry line graphs, and fallback states appear according to the data available for each flight.

**Acceptance Scenarios**:

1. **Given** the pilot has saved flights, **When** the pilot opens the Logbook, **Then** flights are listed with enough information to distinguish start date/time, aircraft, battery, duration, and import status.
2. **Given** a saved manual flight has no GPS or telemetry data, **When** the pilot opens the flight detail, **Then** the detail shows the recorded manual fields and clear non-telemetry fallback states.
3. **Given** a saved imported flight includes GPS points, **When** the pilot opens the flight detail, **Then** the GPS track is viewable on a map without requiring the original imported file.
4. **Given** a saved imported flight includes mAh used, pack voltage, RSSI, LQ, or other telemetry series, **When** the pilot opens the flight detail, **Then** each available series can be viewed as a line graph with telemetry value on the Y axis and elapsed flight time on the X axis.
5. **Given** a saved imported flight includes a derived flight distance, **When** the pilot opens the flight detail or Pilot Profile totals refresh, **Then** the distance is available for display and profile total-distance calculation.

---

### User Story 4 - Correct or Remove Flight Entries (Priority: P4)

As a pilot, I want to correct or remove saved flight entries so that the logbook, aircraft usage, and battery usage remain trustworthy when I notice an entry mistake.

**Why this priority**: Flight records drive aircraft and battery history, so pilots need a controlled way to fix mistakes without corrupting linked records.

**Independent Test**: Can be tested by saving a flight, editing its aircraft, battery, start date/time, duration, voltage, and mAh values, confirming the updated flight persists after relaunch, then removing the flight and verifying the referenced aircraft and battery records remain intact.

**Acceptance Scenarios**:

1. **Given** a saved flight has incorrect manual details, **When** the pilot edits and saves corrected values, **Then** the flight detail, Logbook list, aircraft usage, and battery usage reflect the corrected saved entry.
2. **Given** a saved imported flight has the wrong aircraft or battery assignment, **When** the pilot changes the assignment, **Then** the imported telemetry remains attached to the flight and derived aircraft or battery usage updates to the corrected references.
3. **Given** the pilot chooses to remove a saved flight, **When** the pilot confirms the removal, **Then** the flight no longer appears in the Logbook and the referenced aircraft and battery records are not deleted.

### Edge Cases

- The pilot has no active aircraft in the Hangar.
- The pilot has no active batteries in Battery Tracker.
- The pilot has active aircraft but no active batteries, or active batteries but no active aircraft.
- The pilot attempts to select an inactive aircraft or retired battery for a new flight.
- The pilot records flights with the same start date/time, overlapping flight time ranges, the same aircraft, the same battery, or identical durations.
- The pilot enters a future flight start date/time.
- The current location is unavailable, disabled, denied, delayed, or inaccurate when the manual location map appears.
- Location services or location permission are not enabled, and the pilot chooses whether to open system settings, choose a location manually, or continue without a location.
- The pilot moves the map away from the default current location, clears the selected location, or skips location selection.
- The pilot records a manual flight location that differs from a later imported GPS track for a similar flight.
- The pilot enters a zero, negative, missing, non-numeric, or unusually long flight duration.
- The pilot leaves flight distance, starting voltage, ending voltage, or mAh used unknown.
- The pilot enters zero, negative, non-numeric, or unusually high flight distance, starting voltage, ending voltage, or mAh used.
- The pilot enters an ending voltage greater than starting voltage.
- The pilot changes the aircraft or battery assignment after a flight has already contributed to usage summaries.
- The referenced aircraft is renamed, edited, made inactive, restored, or missing from default active selection after the flight is saved.
- The referenced battery is renamed, edited, retired, restored, or missing from default active selection after the flight is saved.
- The EdgeTX log contains no GPS data, no RSSI data, no LQ data, or only partial telemetry.
- The EdgeTX log contains multiple flight sessions, interrupted sessions, or long idle periods before or after the actual flight, and the pilot chooses whether to manually split the import.
- The EdgeTX log includes GPS points before the aircraft starts flying.
- The EdgeTX log includes armed flags, no armed flags, throttle samples, no throttle samples, or conflicting armed and throttle signals.
- The first flight-start signal occurs before any valid GPS position is available.
- The EdgeTX log contains values that conflict with manually entered corrections.
- A manual entry, manual edit, EdgeTX import, or manually split import segment has the same or overlapping flight time range as an already saved flight, and the pilot chooses whether to save anyway or review/edit.
- The EdgeTX log is malformed, unsupported, empty, very large, or cannot be read.
- Telemetry samples are irregularly spaced, missing units, contain gaps, or include outlier values.
- Telemetry series for mAh used, pack voltage, RSSI, or LQ are absent, partially present, have a single sample, or use inconsistent sample timing.
- GPS points are missing, sparse, duplicated, out of order, or obviously invalid.
- An imported GPS track has too few valid points, invalid points, or gaps that prevent a trustworthy derived distance.
- A saved GPS track has too few valid points to draw a meaningful route but still has a derived flight location.
- The pilot opens a GPS track map for a long flight, sparse flight, or flight with telemetry gaps.
- The app is backgrounded or relaunched while the pilot is creating, editing, importing, reviewing, saving, or removing a flight.
- The pilot uses VoiceOver, larger text sizes, reduced motion, or other accessibility settings while logging flights, reviewing GPS tracks, reading telemetry graphs, or correcting saved entries.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Logbook MUST provide a flight history for the current pilot.
- **FR-002**: The pilot MUST be able to create a manual flight log entry for a completed flight.
- **FR-003**: The saved Flight domain record MUST include one aircraft reference and one battery reference as required information.
- **FR-004**: A new saved flight log entry MUST reference one active aircraft from the Hangar at the time of entry.
- **FR-005**: A new saved flight log entry MUST reference one active battery from Battery Tracker at the time of entry.
- **FR-006**: The Logbook MUST provide clear empty or blocked states when no active aircraft or no active batteries are available for a new flight.
- **FR-007**: The flight start date/time for a new manual entry MUST default to the current local date/time.
- **FR-008**: The pilot MUST be able to change the flight start date/time to another valid past or current date/time.
- **FR-009**: The Logbook MUST prevent saving a flight with a future start date/time.
- **FR-010**: Each saved flight MUST capture a positive flight duration and derive a flight time range from the start date/time plus duration.
- **FR-011**: The manual entry flow MUST ask for optional flight distance, starting voltage, ending voltage, and mAh used.
- **FR-012**: The Logbook MUST allow flight distance, starting voltage, ending voltage, and mAh used to remain unknown when the pilot does not have those values.
- **FR-013**: When starting voltage or ending voltage is provided, the Logbook MUST validate that the value is a positive numeric pack voltage.
- **FR-014**: When both starting voltage and ending voltage are provided, the Logbook MUST prevent saving an ending voltage greater than the starting voltage unless the pilot corrects the values.
- **FR-015**: When mAh used is provided, the Logbook MUST validate that the value is a positive numeric value.
- **FR-015a**: When manual flight distance is provided, the Logbook MUST validate that the value is a positive numeric distance in the app's current display units.
- **FR-016**: The system MUST present clear, recoverable feedback when a manual flight cannot be saved because required or provided fields are invalid.
- **FR-017**: Saved manual flight entries MUST remain available after leaving the Logbook, app relaunch, and offline use.
- **FR-018**: Saved flights MUST retain historical aircraft and battery identity when the referenced aircraft or battery is renamed, edited, removed from active selection, retired, restored, or otherwise unavailable for default new-flight selection.
- **FR-019**: The Logbook MUST list saved flights with start date/time, aircraft, battery, duration, and source status so the pilot can distinguish entries.
- **FR-020**: The pilot MUST be able to open a saved flight and review all recorded manual fields.
- **FR-021**: Additional saved flight details beyond aircraft and battery references MUST remain attached to the same Flight record so the Logbook presents one coherent record per completed flight.
- **FR-022**: The pilot MUST be able to import EdgeTX CSV telemetry log files with a header row as a source for flight entries.
- **FR-023**: EdgeTX import MUST create review drafts before saving any imported flight.
- **FR-024**: EdgeTX import review drafts MUST show every recognized flight start date/time, duration, voltage, mAh, GPS track, derived flight distance when the GPS track supports it, and telemetry field extracted from the selected log.
- **FR-025**: If an imported log does not confidently identify a saved aircraft, the pilot MUST choose an active aircraft before saving the imported flight.
- **FR-026**: If an imported log does not confidently identify a saved battery, the pilot MUST choose an active battery before saving the imported flight.
- **FR-027**: The pilot MUST be able to edit extracted start date/time, duration, voltage, mAh, aircraft, and battery values in an import review draft before saving.
- **FR-028**: EdgeTX import MUST initially treat each selected log file as one flight candidate unless the pilot manually splits it during import review.
- **FR-029**: When the pilot manually splits an imported log, each resulting flight candidate MUST be reviewable, editable, saveable, or discardable independently.
- **FR-030**: The Logbook MUST warn before saving or updating any manual or imported flight whose flight time range starts at the same date/time as, or overlaps, an existing saved flight's time range; the warning MUST be nonblocking and MUST let the pilot either explicitly save anyway or return to review/edit the flight details before saving.
- **FR-031**: Unsupported, non-CSV, headerless, malformed, empty, unreadable, or unusable EdgeTX logs MUST NOT create saved flights.
- **FR-032**: Saved imported flights MUST preserve extracted GPS tracks when GPS points are present.
- **FR-033**: Saved imported flights MUST preserve extracted telemetry series when telemetry values are present.
- **FR-034**: Saved imported flights MUST support at minimum RSSI and LQ telemetry graph review when those series are present in the imported log.
- **FR-035**: Saved imported flights MUST support clear fallback states for missing GPS tracks, missing telemetry series, missing units, sparse samples, or telemetry gaps.
- **FR-036**: GPS track review MUST identify when a flight has no usable GPS data rather than implying a track exists.
- **FR-037**: Telemetry graph review MUST identify the series name, units when known, flight time range, latest value when available, and enough summary information to be understandable without reading every sample.
- **FR-038**: The pilot MUST be able to edit a saved flight's aircraft, battery, start date/time, duration, distance, starting voltage, ending voltage, and mAh used.
- **FR-039**: Editing manual fields on an imported flight MUST NOT remove its saved GPS track or telemetry data unless the pilot explicitly removes those imported details.
- **FR-040**: The pilot MUST be able to remove a saved flight from the Logbook after a clear confirmation.
- **FR-041**: Removing a saved flight MUST NOT delete the referenced aircraft record, referenced battery record, or other saved flights.
- **FR-042**: Aircraft usage summaries, battery usage summaries, and pilot profile flight statistics MUST derive from the current set of saved flight entries, including known flight distance values.
- **FR-043**: Editing or removing a saved flight MUST update derived aircraft usage, battery usage, and pilot profile flight statistics to match the current saved logbook.
- **FR-044**: The Logbook MUST provide understandable fallback states for empty flight history, incomplete optional fields, unavailable imported details, invalid imports, and historical references to inactive aircraft or retired batteries.
- **FR-045**: Logbook diagnostics MUST record safe events for flight list load, manual flight create, flight update, flight removal, EdgeTX import started, EdgeTX import review created, manual import split, EdgeTX import saved, flight time overlap warning, import failure, GPS track review, telemetry graph review, and recoverable persistence failures.
- **FR-046**: Logbook diagnostics MUST NOT include aircraft names, battery names, flight start date/times, durations, distance values, voltage values, mAh values, GPS coordinates, telemetry samples, imported file contents, or other pilot-specific flight details.
- **FR-047**: The Logbook MUST support accessible labels, values, focus order, text scaling, and touch targets for manual entry, aircraft selection, battery selection, import review, flight list browsing, flight detail review, GPS track review, telemetry graph review, editing, and removal confirmation.
- **FR-048**: GPS tracks and telemetry graphs MUST provide accessible summaries that convey the presence, type, time range, and latest or notable values where enough data exists.
- **FR-049**: The manual entry flow MUST ask the pilot whether to provide an optional flight location on a map.
- **FR-050**: A manual flight MUST remain saveable when the pilot skips, clears, or cannot provide a flight location.
- **FR-051**: When current location is available for manual entry, the optional flight location map MUST default to the user's current location.
- **FR-052**: When current location is unavailable for manual entry, the optional flight location map MUST provide a clear nonblocking fallback and still allow the pilot to choose a location manually or save without a location.
- **FR-053**: The pilot MUST be able to adjust or clear the selected manual flight location before saving.
- **FR-054**: A saved manual flight location MUST remain attached to the saved flight and be reviewable from flight detail after leaving the Logbook, app relaunch, and offline use.
- **FR-055**: Manual flight location MUST be treated separately from imported GPS tracks; saving or editing one MUST NOT imply or overwrite the other unless the pilot explicitly changes that flight's location details.
- **FR-056**: When current location cannot be used because location services or location permission are not enabled, the manual location flow MUST present a link to the appropriate system setting to enable location access.
- **FR-057**: Presenting the location settings link MUST NOT block the pilot from manually choosing a location, clearing location, skipping location, or saving the flight when required flight fields are valid.
- **FR-058**: When an imported flight candidate includes a GPS track, the import review draft MUST set the flight location to the first valid GPS position saved after the aircraft started flying.
- **FR-059**: When imported telemetry includes armed flags, the Logbook MUST determine aircraft started flying from the first armed state for that flight candidate before deriving the flight location.
- **FR-060**: When imported telemetry does not include armed flags but includes throttle data, the Logbook MUST determine aircraft started flying from the first throttle value greater than zero for that flight candidate before deriving the flight location.
- **FR-061**: When an imported GPS track cannot be matched to an armed state or first throttle-above-zero signal, the Logbook MUST preserve the GPS track, avoid assigning a misleading derived flight location, and make the missing derived location clear in import review.
- **FR-062**: The pilot MUST be able to review and correct the derived imported flight location before saving the imported flight.
- **FR-063**: When a saved flight includes a GPS track, the pilot MUST be able to view the GPS track on a map from the flight detail.
- **FR-064**: The GPS track map MUST show the saved track route when enough valid GPS points are available and MUST show the flight location when a route cannot be meaningfully drawn but a location is available.
- **FR-065**: The GPS track map MUST provide clear fallback messaging when a saved flight has no GPS track, no usable GPS points, or not enough valid points to draw a meaningful route.
- **FR-066**: When imported telemetry includes mAh used, pack voltage, RSSI, or LQ samples, the pilot MUST be able to view each available series as a line graph from the flight detail.
- **FR-067**: Telemetry line graphs MUST use elapsed flight time on the X axis and the telemetry series value on the Y axis.
- **FR-068**: Telemetry line graphs MUST preserve the timing relationship between samples so each plotted value appears at the time in the flight when it occurred.
- **FR-069**: Telemetry line graph review MUST provide clear fallback states for absent series, single-sample series, irregular sample timing, missing units, telemetry gaps, and outlier values.
- **FR-070**: The Logbook MUST support mAh used, pack voltage, RSSI, and LQ as named telemetry graph types when those series are present in imported flight data.
- **FR-071**: After an imported flight is saved, cancelled, discarded, or fails import, the Logbook MUST NOT retain the original EdgeTX CSV file contents; saved flights MUST retain only parsed flight data, GPS tracks, telemetry series, source status, and safe import metadata needed by the saved flight.
- **FR-072**: Manual flight entry MUST allow an optional pilot-entered flight distance; manual flights with no entered distance have unknown distance for profile total-distance calculations.
- **FR-073**: When an imported flight candidate includes enough valid ordered GPS points, the Logbook MUST derive and save the flight distance from the GPS track.
- **FR-074**: When an imported GPS track is absent, unusable, or has too few valid points to derive a trustworthy distance, the Logbook MUST leave flight distance unknown rather than estimating or requiring pilot entry.
- **FR-075**: Known saved flight distance values MUST be available to Pilot Profile total-distance calculations, while unknown flight distance values MUST NOT block saving, reviewing, or summarizing other flight data.

### Key Entities

- **Flight**: Represents one logged aircraft use event for the current pilot. Required information is the aircraft flown and battery used; Flight Logging adds start date/time, duration, flight time range, optional flight location, optional flight distance, optional battery usage details, source status, optional GPS track, and optional telemetry series to make the record useful in the Logbook.
- **Aircraft Reference**: Represents the durable link from a saved flight to the aircraft record flown, preserving historical flight identity even when the aircraft later leaves active inventory.
- **Battery Reference**: Represents the durable link from a saved flight to the battery pack used, preserving historical flight identity even when the battery is later retired or otherwise leaves active selection.
- **Flight Time Range**: Represents the occupied interval from a flight's start date/time through its duration, used to warn about same-time and overlapping saved flight entries.
- **Manual Flight Details**: Represents values entered or corrected by the pilot, including start date/time, duration, optional flight location, optional flight distance, starting voltage, ending voltage, and mAh used.
- **Flight Location**: Represents a single reviewable location for the saved flight. Manual entries use an optional map-selected location, while imported flights with GPS tracks derive the location from the first valid GPS point after the aircraft started flying.
- **Flight Distance**: Represents an optional distance value either entered by the pilot for a manual flight or derived from an imported GPS track with enough valid ordered points.
- **Flight Start Signal**: Represents the telemetry evidence used to decide when the aircraft started flying for imported GPS location derivation, preferring armed flags and falling back to first throttle value greater than zero when armed flags are absent.
- **EdgeTX Import**: Represents one pilot-selected EdgeTX CSV telemetry log import attempt with a header row, including the initial one-flight candidate, any pilot-created split candidates, recognized values, import warnings, and review drafts. Original CSV contents are transient import input and are not retained after save, cancellation, discard, or failure.
- **Import Review Draft**: Represents an unsaved flight candidate produced from an EdgeTX log that the pilot can review, complete, split, edit, save, or discard.
- **GPS Track**: Represents ordered location points extracted from an imported flight and associated with the saved flight entry, reviewable as a route on a map when enough valid points are available.
- **Telemetry Series**: Represents timestamped readings extracted from an imported flight, such as mAh used, pack voltage, RSSI, LQ, current, or other available radio telemetry.
- **Telemetry Line Graph**: Represents a visual review of one telemetry series with elapsed flight time on the X axis and the series value on the Y axis.
- **Flight Source Status**: Represents whether a saved flight was created manually, imported from EdgeTX, or manually corrected after import.
- **Derived Usage Summary**: Represents aircraft usage, battery usage, and pilot profile flight statistics calculated from saved flight entries, including known saved flight distance values.

## Operational Considerations *(mandatory when feature changes state, persistence, lifecycle, or telemetry)*

- **State Owner**: The app must maintain one authoritative Logbook for the current pilot. The Flight domain record owns the aircraft and battery references required by the proposed data model plus its recorded manual values, flight location, flight distance, imported GPS or telemetry data, and derived imported location. Aircraft and battery identity remain owned by the Hangar and Battery Tracker, with the Logbook storing durable references rather than copied names.
- **Lifecycle / Offline Behavior**: Manual entries, optional manual flight locations, optional flight distances, saved imported flights, edits, removals, GPS tracks, telemetry series, and derived usage relationships must remain available from SwiftData-backed local storage offline, after backgrounding, after relaunch, and after same-pilot iCloud sync makes Logbook data available on another device. Interrupted manual entry, location selection, import review, edit, removal, or sync updates must either complete safely or leave the last saved Logbook state intact.
- **Observability**: Diagnostic events must help identify list load failures, manual save failures, invalid field validation, current-location fallback, location settings link presentation, manual location selection or clearing, import parsing failures, flight time overlap warnings, review draft creation, imported GPS-derived location assignment or fallback, imported save failures, edit failures, removal failures, GPS review failures, telemetry review failures, and recoverable persistence issues without exposing pilot-specific flight details or imported payloads.
- **Privacy / Data Sensitivity**: Flight start date/times, durations, aircraft references, battery references, manual flight locations, current location used for map defaults, distance values, voltage values, mAh values, GPS tracks, telemetry samples, and imported EdgeTX logs are pilot-specific operational data. They must remain local-first, sync only through the pilot's iCloud account for cross-device continuity, and must not be shared outside that account except through explicit pilot action. Original EdgeTX CSV contents must be treated as transient import input and not retained after the import attempt completes.
- **HIG / Platform Alignment**: The Logbook must follow native iOS navigation, list, form entry, optional location selection, permission recovery, document import, confirmation, feedback, chart, map, and accessibility conventions. Manual location entry must be optional, clear, and nonblocking, including when offering a system settings link for location access. Import review must make automated extraction, including GPS-derived flight location, transparent and correctable before saving. GPS track maps and telemetry line graphs must remain useful with VoiceOver, larger text, reduced motion, and non-visual summaries.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A pilot can create a manual flight with active aircraft, active battery, start date/time, duration, and any known battery details in under 2 minutes during validation.
- **SC-002**: In 100% of validation runs for new manual entries, the flight start date/time defaults to the current local date/time and can be changed to a valid past date/time before saving.
- **SC-003**: In validation cases covering missing aircraft, missing battery, future start date/time, missing duration, zero duration, negative duration, valid duration, invalid distance, valid distance, invalid voltage, valid voltage, invalid mAh, valid mAh, and unknown optional distance or battery values, the Logbook accepts or rejects saves according to the specified rules with 100% accuracy.
- **SC-004**: 100% of saved manual flights continue to show the same aircraft reference, battery reference, start date/time, duration, optional distance, voltage values, and mAh value after leaving the Logbook and relaunching the app.
- **SC-005**: For validation EdgeTX logs containing one flight with start date/time, duration, voltage, mAh, GPS, RSSI, and LQ values, import review drafts show all recognized values with 100% accuracy against the known sample data.
- **SC-006**: In validation EdgeTX imports where aircraft or battery cannot be identified, 100% of review drafts require pilot selection of the missing reference before save.
- **SC-007**: In validation cases covering valid CSV-with-header, non-CSV, headerless, malformed, empty, unsupported, same-time overlap, no-overlap, no-GPS, no-telemetry, partial-telemetry, and multi-session EdgeTX logs, the import flow initially creates one flight candidate per log file and produces the specified save, split, review, warning, or failure behavior with 100% accuracy.
- **SC-008**: In validation with imported flights up to 60 minutes long and up to 10,000 telemetry samples, the flight detail shows available GPS track and telemetry graph review within 2 seconds in at least 95% of runs.
- **SC-009**: In validation scenarios, editing or removing a saved flight updates Logbook detail, aircraft usage, battery usage, and pilot profile flight statistics to match the current saved entries with 100% accuracy.
- **SC-010**: Accessibility validation finds no blocking issues for manual entry, aircraft selection, battery selection, import review, flight list browsing, flight detail review, GPS track review, telemetry graph review, editing, or removal confirmation with VoiceOver and large text sizes.
- **SC-011**: In 100% of validation scenarios where a referenced aircraft or battery is renamed, edited, removed from active inventory, retired, or restored after the flight is saved, the saved flight continues to identify the historical aircraft and battery used.
- **SC-012**: In validation cases covering current location available, current location unavailable, location services disabled, location permission denied, location skipped, location adjusted, and location cleared during manual entry, the Logbook shows the specified settings link, saves, or omits the optional flight location according to the specified behavior with 100% accuracy.
- **SC-013**: In validation EdgeTX logs with GPS tracks and armed flags, imported flight review drafts set flight location to the first valid GPS position after the first armed state with 100% accuracy against known sample data.
- **SC-014**: In validation EdgeTX logs with GPS tracks, no armed flags, and throttle samples, imported flight review drafts set flight location to the first valid GPS position after throttle first becomes greater than zero with 100% accuracy against known sample data.
- **SC-015**: In validation EdgeTX logs with multiple flights, the import review initially treats each log file as one flight candidate and preserves correct data after the pilot manually splits it in 100% of cases.
- **SC-016**: In validation EdgeTX logs with GPS tracks but no usable armed or throttle flight-start signal, import review preserves the GPS track and avoids assigning a derived flight location in 100% of cases.
- **SC-017**: In validation flights with no GPS track, one valid GPS point, sparse GPS points, and a full GPS route, the flight detail shows the specified map route, map location, or fallback behavior with 100% accuracy.
- **SC-018**: In validation flights with mAh used, pack voltage, RSSI, and LQ telemetry samples, each available series is viewable as a line graph with elapsed flight time on the X axis and the series value on the Y axis with 100% accuracy against known sample data.
- **SC-019**: In validation flights with absent, single-sample, irregularly timed, gap-containing, and outlier-containing telemetry series, telemetry graph review shows the specified graph or fallback behavior with 100% accuracy.
- **SC-020**: In validation cases covering manual create, manual edit, EdgeTX import save, and manually split import save attempts with same start date/time, overlapping flight time range, and non-overlapping flight time range, the Logbook warns only for same-time or overlapping ranges and offers working save-anyway and review/edit paths with 100% accuracy.
- **SC-021**: In validation imports covering saved, cancelled, discarded, and failed EdgeTX CSV attempts, persistent Logbook storage contains the parsed saved flight data when applicable and does not retain the original CSV file contents in 100% of cases.
- **SC-022**: In validation manual entries and imports with known distance inputs, 100% of saved flights include the saved flight distance available to Pilot Profile totals; manual flights without entered distance and imports without usable GPS distance inputs save with unknown distance.

## Assumptions

- Flight Logging is scoped to the current pilot using the app; multi-pilot sharing is out of scope for this feature.
- Same-pilot cross-device sync through iCloud is in scope for the product and will be specified by the dedicated iCloud sync feature.
- The proposed platform-neutral Flight data model currently defines aircraft and battery as the required core Flight fields. This feature extends that core Flight record with start date/time, duration, flight time range, optional battery usage values, optional flight distance, import status, GPS tracks, and telemetry series for Logbook use.
- Creating aircraft and batteries remains the responsibility of the Hangar and Battery Tracker. The Logbook provides clear blocked states or navigation paths when required active records do not exist.
- Aircraft, battery, flight start date/time, and flight duration are required for a saved flight.
- A flight's time range is derived from its start date/time and duration; same or overlapping flight time ranges trigger nonblocking warnings for manual and imported flight save/update attempts.
- Manual flight location is optional and represents a single pilot-selected location for the flight, not a full GPS track.
- Manual flight entries may capture optional pilot-entered flight distance. If the pilot leaves distance blank, the saved flight has unknown distance for Pilot Profile total-distance calculations.
- Current location is used only to default the optional manual flight location map when available; it is not required for saving a manual flight.
- A system settings link is only used to help the pilot enable location access for the optional map default; it must not make location mandatory for manual flight logging.
- Imported GPS tracks can derive a flight location automatically. Armed flags are the preferred flight-start signal; first throttle value greater than zero is used only when armed flags are absent.
- Imported GPS tracks can derive flight distance when enough valid ordered GPS points are available.
- When neither armed flags nor throttle samples can identify when the aircraft started flying, the imported GPS track remains available but the flight location is not automatically derived.
- EdgeTX imports initially treat each selected log file as one flight candidate. Splitting a log into multiple flights is an explicit pilot review action.
- Starting voltage, ending voltage, and mAh used are requested during manual entry but may be left unknown because pilots may not have those values for every flight.
- Manual starting and ending voltage values represent pack voltage in volts.
- EdgeTX import is limited to CSV telemetry logs with a header row produced by EdgeTX-compatible radio/controller logging. Importing folder bundles, archives, headerless logs, non-CSV files, and other radio ecosystems is out of scope unless planned separately.
- Imported flights are reviewed by the pilot before they become saved flight entries.
- Saved imported flights retain parsed values, GPS tracks, telemetry series, and safe import metadata needed by the saved flight, but they do not retain the original EdgeTX CSV file contents.
- GPS tracks and telemetry graphs are shown only when those data are present or recognized in the imported log; the Logbook does not infer missing GPS or telemetry.
- Telemetry graph X-axis values represent elapsed time within the imported flight candidate or manually split segment, not wall-clock time, unless a later planning decision explicitly adds wall-clock display as supporting context.
- Removing a flight means removing it from the active Logbook and derived usage summaries; deleting aircraft or battery records is out of scope for Flight Logging.
