# Feature Specification: Battery Tracker

**Feature Branch**: `003-battery-tracker`

**Created**: 2026-06-04

**Status**: Draft

**Input**: User description: "Battery Tracker: The Battery Tracker is a lifecycle and safety management module for aircraft. It provides usage tracking and a specialized manual entry system for monitoring internal resistance (IR). By tracking the health of individual cells over time, the app alerts pilots to aging packs or soft cells before they become a flight hazard. Batteries can be referenced from flights in flight log. Reference the included data model for batteries for details."

## Clarifications

### Session 2026-06-04

- Q: What battery health information can be captured from a flight log? -> A: A flight log only needs to record that a particular pack was used. Optional flight-level battery details are mAh used and ending voltage; flight data must not be used to infer internal resistance or measured pack capacity.
- Q: How are internal resistance and measured capacity tracked? -> A: IR tracking is manually initiated by the pilot and can only be gathered when the battery is charged. Capacity tracking is a separate charger-based check where the pilot fully charges the battery, drains it fully on the charger, and records the measured mAh. IR checks and capacity checks can be recorded together in one maintenance session or separately.
- Q: How should capacity and IR be visualized over time? -> A: Battery Tracker should provide charts for health history. Capacity should use a line graph, IR should use a bar graph, and both chart types should use the battery's accumulated number of flights on the X axis with capacity or IR in milliohms on the Y axis.
- Q: What rules determine pack health? -> A: Battery Tracker should classify pack health as Healthy, Monitor / demote, Ill health / retire for demanding use, or Retire. The classification should use the latest IR cell relationship plus pilot-recorded condition observations such as normal performance and temperature, voltage sag, imbalance after use, puffing, unusual heat, inability to stay balanced, or physical damage.
- Q: What should happen when a battery reaches the Retire health classification? -> A: Battery Tracker prompts the pilot to retire the battery, but requires confirmation before changing lifecycle status.
- Q: How should non-healthy active batteries behave during flight selection? -> A: Active batteries remain selectable without extra flight-selection warnings based only on health classification; retiring the battery is what removes it from default flight selection.
- Q: Should measured capacity affect pack health classification? -> A: Measured capacity is tracked, compared with stated capacity, and charted over time, but it does not change pack health classification.
- Q: What unit should internal resistance use? -> A: Internal resistance is recorded, saved, displayed, and charted in milliohms.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Register Battery Packs (Priority: P1)

As a recreational UAV pilot, I want to add each physical battery pack to Battery Tracker with its identifying and pack details so that I can reliably choose the correct pack for flights and safety review.

**Why this priority**: Battery Tracker needs an accurate inventory before usage, IR history, measured capacity history, or lifecycle health classifications can be trusted.

**Independent Test**: Can be fully tested by creating a battery with a required numeric pack identifier, name, chemistry, cell count, capacity, and connector, saving it, leaving Battery Tracker, returning, and verifying the same battery record is present.

**Acceptance Scenarios**:

1. **Given** the pilot has no batteries recorded, **When** the pilot creates a battery with all required details, **Then** the battery appears in the active battery inventory.
2. **Given** the pilot enters optional brand information for a battery, **When** the battery is saved, **Then** the saved record shows the brand on the battery detail.
3. **Given** the pilot attempts to save a battery without a required field, **When** the save is submitted, **Then** the battery is not saved and the pilot receives clear feedback identifying the missing field.
4. **Given** the pilot attempts to reuse an existing battery identifier, **When** the save is submitted, **Then** the battery is not saved and the pilot receives clear feedback that each physical pack needs a unique identifier.

---

### User Story 2 - Enter and Review Internal Resistance (Priority: P2)

As a pilot, I want to manually record charger-provided internal resistance readings while a battery is charged so that I can compare individual cells and spot pack health changes over time.

**Why this priority**: Cell-level IR tracking is the feature's primary safety value and gives pilots early warning before a weak cell becomes a flight hazard.

**Independent Test**: Can be tested by creating batteries from 1S through 8S, manually initiating an IR check, entering one charger-provided milliohm IR reading per cell, saving multiple dated reading sessions at different flight counts, and verifying the detail view shows the latest readings, historical trend, cell-level comparison, and IR bar chart in milliohms for each pack.

**Acceptance Scenarios**:

1. **Given** a 4S battery exists, **When** the pilot manually starts an IR check, **Then** the entry flow explains the battery should be charged and requires exactly four milliohm cell readings before saving.
2. **Given** the pilot records multiple IR checks for the same battery over time, **When** the pilot opens the battery detail, **Then** the latest readings and prior readings are shown in milliohms for comparison.
3. **Given** one cell's latest IR reading is materially higher than the pack average, **When** the IR check is saved, **Then** the battery detail shows the appropriate pack health classification and identifies the cell that drove it.
4. **Given** the latest IR readings are close together and the pilot records normal performance and temperature, **When** the check is saved, **Then** the battery detail classifies the pack as Healthy.
5. **Given** a flight log includes mAh used or ending voltage, **When** the pilot views IR history, **Then** the flight data is not shown as an IR check and does not change the pack health classification by itself.
6. **Given** a battery has saved IR checks, **When** the pilot views IR history, **Then** Battery Tracker shows an IR bar graph with accumulated flight count on the X axis and IR in milliohms on the Y axis.

---

### User Story 3 - Record Measured Capacity (Priority: P3)

As a pilot, I want to record charger-based capacity checks so that I can compare measured pack capacity against the battery's stated capacity and aging history.

**Why this priority**: Capacity loss is a practical lifecycle signal that complements IR health without relying on flight logs to approximate pack condition.

**Independent Test**: Can be tested by creating a battery, recording a capacity check with a measured mAh value after a full charge and full charger drain, saving capacity-only and combined IR-plus-capacity sessions at different flight counts, and verifying the battery detail shows latest measured capacity, historical measured capacity, and a capacity line graph.

**Acceptance Scenarios**:

1. **Given** a battery exists, **When** the pilot starts a capacity check, **Then** the entry flow explains the battery should be fully charged, fully drained on the charger, and recorded with the measured mAh from that charger process.
2. **Given** the pilot records a valid measured capacity value, **When** the capacity check is saved, **Then** the battery detail shows the latest measured capacity and how it compares with the battery's stated capacity.
3. **Given** the pilot records capacity checks over time, **When** the pilot opens the battery detail, **Then** prior capacity checks are available for comparison.
4. **Given** the pilot wants to record IR and measured capacity from the same charger session, **When** both sets of values are entered before saving, **Then** Battery Tracker saves both the IR check and capacity check together.
5. **Given** the pilot only has IR readings or only has measured capacity from a charger session, **When** the check is saved, **Then** Battery Tracker saves the available check without requiring the other one.
6. **Given** a battery has saved measured capacity checks, **When** the pilot views capacity history, **Then** Battery Tracker shows a capacity line graph with accumulated flight count on the X axis and measured capacity on the Y axis.
7. **Given** a measured capacity value is lower than the battery's stated capacity, **When** the capacity check is saved, **Then** Battery Tracker records, compares, and charts the value without changing pack health classification based on capacity alone.

---

### User Story 4 - Track Battery Usage From Flights (Priority: P4)

As a pilot, I want flight logs to reference batteries from Battery Tracker so that pack usage accumulates from real flights instead of manual tallying.

**Why this priority**: Usage history is required to understand battery lifecycle, retirement decisions, and flight risk alongside manually recorded IR and measured capacity health.

**Independent Test**: Can be tested by creating a battery, selecting it for multiple flight logs, optionally adding mAh used and ending voltage, and confirming Battery Tracker reflects updated flight count, last-used information, optional discharge details, and preserved flight references after relaunch.

**Acceptance Scenarios**:

1. **Given** the pilot has active batteries, **When** the pilot records a flight, **Then** the pilot must choose the active battery pack used for that flight.
2. **Given** the pilot records a flight with a battery, **When** the pilot does not know mAh used or ending voltage, **Then** the flight can still be saved with the battery reference.
3. **Given** the pilot records optional mAh used or ending voltage for a flight, **When** the pilot views that battery, **Then** the battery usage summary can show those optional flight details separately from IR and capacity checks.
4. **Given** saved flights reference a battery, **When** the pilot views that battery, **Then** the battery usage summary includes the number of saved flights using that battery and its most recent flight use.
5. **Given** a saved flight references a battery, **When** the battery's name, brand, connector, or capacity is edited, **Then** the flight continues to reference the same physical battery record.
6. **Given** a pilot observes unusual sag, heat, post-use imbalance, puffing, inability to stay balanced, or physical damage during or after use, **When** the pilot records that condition on the battery, **Then** Battery Tracker updates the pack health classification according to the severity of that condition.
7. **Given** an active battery has a Monitor / demote, Ill health / retire for demanding use, or Retire health classification, **When** the pilot selects it for a flight before retiring it, **Then** Battery Tracker allows selection without an additional flight-selection warning based only on that classification.

---

### User Story 5 - Retire Unsafe or Aging Batteries (Priority: P5)

As a pilot, I want to retire batteries from active use without losing usage, IR history, or measured capacity history so that unsafe, damaged, or aging packs stop appearing for new flights while their historical records remain available.

**Why this priority**: Lifecycle management must reduce future flight risk without corrupting the logbook or hiding why a pack was retired.

**Independent Test**: Can be tested by creating a battery, logging flights, IR checks, and capacity checks against it, retiring it, confirming it no longer appears by default for new flight selection, and verifying its historical flights, IR history, and capacity history remain visible.

**Acceptance Scenarios**:

1. **Given** a battery has saved flight references, IR history, or capacity history, **When** the pilot retires it, **Then** the battery is removed from active flight selection by default and its historical data remains available.
2. **Given** a retired battery is referenced by past flights, **When** the pilot views those flights, **Then** the flights still identify the retired battery.
3. **Given** the pilot decides a retired battery should be available again, **When** the pilot restores it to active status, **Then** it becomes available for new flight logs.
4. **Given** an active battery reaches the Retire health classification, **When** the classification is shown, **Then** Battery Tracker prompts the pilot to retire the battery but does not retire it until the pilot confirms.

### Edge Cases

- The pilot has no batteries in Battery Tracker.
- The pilot creates batteries with duplicate names, similar names, or the same brand and capacity.
- The pilot attempts to create or edit a battery using a duplicate numeric identifier.
- The pilot enters very long battery names or brand values.
- The pilot does not know the brand but knows the required pack details.
- The pilot changes a battery's name, brand, capacity, connector, chemistry, or cell count after the battery has saved flights or IR readings.
- A battery's cell count changes after prior IR entries exist, making older readings different from the latest pack configuration.
- The pilot tries to save an IR check with missing, extra, negative, zero, non-numeric, or unusually high milliohm readings.
- The pilot tries to save a capacity check with missing, negative, zero, non-numeric, or unusually high measured mAh.
- The pilot records IR and measured capacity in the same maintenance session, or records only one of them.
- The pilot starts an IR check or capacity check but has not actually charged the battery or completed the charger drain process.
- The pilot records normal performance and temperature with an IR check, or records an adverse condition without an IR check.
- Multiple pack health rules apply to the same battery at once.
- A battery reaches the Retire health classification and the pilot dismisses or cancels the retirement prompt.
- A battery has a non-Healthy health classification but remains active because the pilot has not retired it.
- A 1S battery has no cell-to-cell imbalance comparison but can still track aging over time.
- The pilot records IR readings or capacity checks for a battery with no saved flights.
- The pilot has only one saved IR check or one saved capacity check, limiting trend visualization.
- Multiple IR checks or capacity checks are recorded at the same accumulated flight count.
- The pilot logs flights for a battery with no saved IR readings or capacity checks.
- The pilot records a flight with only the required battery reference and no mAh used or ending voltage.
- The pilot records optional flight mAh used or ending voltage values that are missing, negative, zero where invalid, non-numeric, or unusually high.
- The pilot records observed sag more than usual, large voltage sag, unusual heat, puffing, inability to stay balanced, post-use imbalance, or physical damage.
- Multiple batteries have the same latest health classification, usage count, or last-used date.
- A flight references a battery that has since been renamed, edited, retired, restored, or is unavailable.
- A battery has chartable capacity history but no IR history, or chartable IR history but no capacity history.
- The app is backgrounded or relaunched while the pilot is creating, editing, retiring, restoring, selecting, recording IR readings, or recording capacity checks for a battery.
- The pilot uses VoiceOver, larger text sizes, reduced motion, or other accessibility settings while managing batteries, entering IR readings, entering capacity checks, reviewing health classifications, reading charts, or selecting a battery for a flight.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Battery Tracker MUST provide a battery inventory for the current pilot's physical battery packs.
- **FR-002**: The pilot MUST be able to create a battery record with a unique user-visible numeric identifier, pilot-facing name, chemistry, cell configuration, capacity, and connector.
- **FR-003**: The pilot MUST be able to save optional battery brand information.
- **FR-004**: Battery Tracker MUST support the battery chemistry values LiFePo4, Li-ion, LiPo, NiMH, and NiCad.
- **FR-005**: Battery Tracker MUST support the connector values PH 2.0, GNB27, A30, BT 2.0, BT 3.0, XT30, XT60, XT90, Deans, and Other.
- **FR-006**: Battery Tracker MUST support battery cell configurations from 1S through 8S.
- **FR-007**: The system MUST validate that required battery information is present before saving and MUST present clear, recoverable feedback when a record cannot be saved.
- **FR-008**: The system MUST prevent duplicate battery identifiers across active and retired battery records.
- **FR-009**: Saved battery records MUST remain available after leaving Battery Tracker, app relaunch, and offline use.
- **FR-010**: Battery Tracker MUST show a clear empty state when the pilot has not created any active batteries.
- **FR-011**: Battery Tracker MUST display active batteries with enough visible information for the pilot to distinguish entries, including entries with duplicate or similar names.
- **FR-012**: The pilot MUST be able to open a battery record and review all saved identifying, configuration, usage, lifecycle, IR health, condition observation, and measured capacity information.
- **FR-013**: The pilot MUST be able to edit an existing battery record without creating a duplicate physical battery identity.
- **FR-014**: Battery edits MUST preserve the battery identity used by saved flight logs, usage summaries, IR history, and measured capacity history.
- **FR-015**: The pilot MUST be able to manually initiate an IR check for a battery.
- **FR-016**: The IR check entry flow MUST explain that IR readings are gathered while the battery is charged and are not derived from flight logs.
- **FR-017**: Each manual IR check MUST capture one milliohm reading per cell for the battery's selected cell configuration.
- **FR-018**: The manual IR entry flow MUST prevent saving when the reading count does not match the battery's selected cell configuration.
- **FR-019**: The manual IR entry flow MUST prevent saving missing, non-numeric, negative, or zero milliohm readings.
- **FR-020**: Each saved IR check MUST preserve the reading date, the battery's cell configuration at the time of entry, and the individual cell readings in milliohms.
- **FR-021**: Battery Tracker MUST show the latest IR readings for each cell in milliohms on the battery detail.
- **FR-022**: Battery Tracker MUST show prior IR checks in milliohms so the pilot can compare cell health over time.
- **FR-023**: Battery Tracker MUST classify current pack health into Healthy, Monitor / demote, Ill health / retire for demanding use, or Retire.
- **FR-024**: Battery Tracker MUST classify a pack as Healthy when latest IR cell readings are close together with the highest and lowest readings no more than 25% apart and the pilot has not recorded adverse performance, temperature, balance, sag, or damage observations.
- **FR-025**: Battery Tracker MUST classify a pack as Monitor / demote when any cell is more than 25% and no more than 50% higher than the pack average, or when the pilot records that the pack sags more than usual.
- **FR-026**: Battery Tracker MUST classify a pack as Ill health / retire for demanding use when any cell is more than 50% and less than 100% higher than the average of the other cells, or when the pilot records that the pack comes down badly imbalanced after use.
- **FR-027**: Battery Tracker MUST classify a pack as Retire when any cell is at least 2x the average of the other cells, or when the pilot records that the pack puffs, gets unusually hot, has large voltage sag, will not stay balanced, or has physical damage.
- **FR-028**: When multiple pack health rules apply, Battery Tracker MUST show the most severe resulting classification and the reasons that caused it.
- **FR-029**: Battery Tracker MUST preserve historical pack health classifications and reasons with the check or observation that produced them.
- **FR-030**: Battery Tracker MUST allow the active pack health classification to improve when later IR checks and observations no longer meet a more severe rule, while preserving prior classifications in history.
- **FR-031**: When an active battery reaches the Retire health classification, Battery Tracker MUST prompt the pilot to retire the battery.
- **FR-032**: Battery Tracker MUST NOT change a battery's lifecycle status from active to retired without pilot confirmation.
- **FR-033**: The pilot MUST be able to record battery condition observations including normal performance and temperature, sags more than usual, comes down badly imbalanced after use, puffing, unusual heat, large voltage sag, will not stay balanced, and physical damage.
- **FR-034**: Each saved battery condition observation MUST preserve the observation date and the condition that was observed.
- **FR-035**: The pilot MUST be able to manually initiate a measured capacity check for a battery.
- **FR-036**: The capacity check entry flow MUST explain that measured capacity comes from fully charging the battery, fully draining it on a charger, and recording the measured mAh from that charger process.
- **FR-037**: Each measured capacity check MUST capture a positive numeric measured mAh value.
- **FR-038**: Each saved measured capacity check MUST preserve the reading date and measured mAh value.
- **FR-039**: Battery Tracker MUST show the latest measured capacity and prior capacity checks on the battery detail.
- **FR-040**: Battery Tracker MUST compare measured capacity values with the battery's stated capacity without changing pack health classification based on capacity alone.
- **FR-041**: Battery Tracker MUST allow the pilot to save an IR check without a capacity check, a capacity check without an IR check, or both checks from the same maintenance session.
- **FR-042**: New flight logs MUST require a reference to the active battery pack used for the flight rather than storing battery names as unrelated text.
- **FR-043**: Flight logs MAY capture optional battery discharge details: mAh used and ending voltage.
- **FR-044**: Flight logs MUST remain saveable when mAh used and ending voltage are not provided.
- **FR-045**: The system MUST validate optional flight mAh used and ending voltage values when provided and MUST present clear, recoverable feedback for invalid values.
- **FR-046**: Flight log mAh used and ending voltage MUST be shown as flight usage details and MUST NOT create, update, or infer IR checks or measured capacity checks.
- **FR-047**: Saved flights MUST retain their battery references when the referenced battery is edited, retired, or restored.
- **FR-048**: Battery health classification alone MUST NOT hide active batteries from flight selection or require extra flight-selection warnings.
- **FR-049**: Battery Tracker MUST calculate battery usage from saved flight references, including flight count and most recent use.
- **FR-050**: Battery Tracker MUST include optional flight mAh used and ending voltage in battery usage history when those values are available.
- **FR-051**: Battery usage summaries MUST include retired batteries when the pilot views historical battery details or historical flight references.
- **FR-052**: The pilot MUST be able to retire a battery from active use.
- **FR-053**: Retiring a battery MUST remove it from default choices for new flight logs while preserving saved flight references, usage summaries, IR history, measured capacity history, condition observations, and health classification history.
- **FR-054**: The system MUST provide clear confirmation before retiring an active battery.
- **FR-055**: The pilot MUST be able to restore a retired battery to active use.
- **FR-056**: The system MUST prevent battery retirement or restoration from corrupting existing flight history, usage totals, IR history, measured capacity history, condition observations, or health classification history.
- **FR-057**: The system MUST provide understandable fallback states for empty battery inventory, incomplete optional details, unavailable flight history totals, unavailable latest IR readings, unavailable latest capacity checks, unavailable condition observations, retired batteries, and unavailable historical references.
- **FR-058**: Battery Tracker diagnostics MUST record safe events for battery list load, battery create, battery update, IR check create, capacity check create, condition observation create, health classification change, Retire classification prompt, battery selection for a flight, optional flight battery data entry, battery retirement, battery restoration, and recoverable failures.
- **FR-059**: Battery Tracker diagnostics MUST NOT include battery names, brands, identifiers, capacity values, connector values, cell readings, measured capacity values, condition observations, ending voltage values, flight references, or other pilot-specific battery details.
- **FR-060**: Battery Tracker MUST support accessible labels, values, focus order, text scaling, and touch targets for battery browsing, battery detail review, battery editing, IR entry, capacity entry, health classification review, retirement confirmation, restoration, and battery selection from flight logging.
- **FR-061**: Battery Tracker MUST provide a capacity history chart for batteries with saved measured capacity checks.
- **FR-062**: The capacity history chart MUST use a line graph with accumulated battery flight count on the X axis and measured capacity on the Y axis.
- **FR-063**: Battery Tracker MUST provide an IR history chart for batteries with saved IR checks.
- **FR-064**: The IR history chart MUST use a bar graph with accumulated battery flight count on the X axis and IR in milliohms on the Y axis.
- **FR-065**: Chart points or bars MUST use the battery's accumulated saved flight count at the time each IR check or measured capacity check was recorded.
- **FR-066**: Battery Tracker MUST provide clear non-chart fallback states when a battery has no saved capacity checks, no saved IR checks, or only one saved check for a chart type.
- **FR-067**: Battery health charts MUST provide accessible labels or summaries that identify the chart type, axis meanings, units, latest value, and trend direction where enough data exists.

### Key Entities

- **Battery**: Represents one physical battery pack available to the pilot. Key information includes required numeric identifier, name, chemistry, cell configuration, capacity, connector, and optional brand.
- **Cell Configuration**: Represents a battery's series cell count from 1S through 8S and determines the exact number of IR readings required for each manual check.
- **IR Check**: Represents one dated manual internal resistance inspection for a battery, including the cell configuration at the time of entry and one milliohm reading per cell.
- **Measured Capacity Check**: Represents one dated charger-based capacity inspection for a battery, including the measured mAh recorded after the pilot fully charges the battery and fully drains it on the charger.
- **Battery Maintenance Session**: Represents a pilot-initiated battery health entry that may contain an IR check, a measured capacity check, or both.
- **Battery Condition Observation**: Represents a dated pilot-recorded battery condition, such as normal performance and temperature, sag more than usual, post-use imbalance, puffing, unusual heat, large voltage sag, inability to stay balanced, or physical damage.
- **Battery Health Classification**: Represents the current and historical pack health state derived from IR checks and battery condition observations: Healthy, Monitor / demote, Ill health / retire for demanding use, or Retire.
- **Battery Health Chart**: Represents a visual history of battery health checks, using capacity line graphs and IR bar graphs plotted against accumulated battery flight count.
- **Battery Usage Summary**: Represents usage derived from saved flight references, including flight count, most recent use, and optional flight-level mAh used or ending voltage values when recorded.
- **Battery Lifecycle Status**: Represents whether a battery is active for new flight selection or retired while preserved for historical usage, IR review, and capacity review.
- **Battery Reference**: Represents the durable link from a saved flight log to the battery record used for that flight.
- **Flight Log Entry**: Represents a saved flight that must reference one Battery Tracker battery for this feature and may optionally record mAh used and ending voltage.

## Operational Considerations *(mandatory when feature changes state, persistence, lifecycle, or telemetry)*

- **State Owner**: The app must maintain one authoritative Battery Tracker inventory for the current pilot. Flight logs must consume battery references from that inventory rather than owning separate battery copies. IR history, condition observations, measured capacity history, usage summaries, lifecycle status, and active health classification belong to the battery record they describe.
- **Lifecycle / Offline Behavior**: Battery records, IR checks, condition observations, measured capacity checks, usage summaries derived from saved flights, optional flight battery details, lifecycle status, and health classification state must remain available from SwiftData-backed local storage offline, after backgrounding, after relaunch, and after same-pilot iCloud sync makes Battery Tracker data available on another device. Interrupted create, edit, IR entry, condition observation, capacity entry, flight selection, retirement, restoration, or sync updates must either complete safely or leave the last saved battery state intact.
- **Observability**: Diagnostic events must help identify battery list load failures, save failures, IR entry failures, condition observation failures, capacity entry failures, health classification changes, flight selection failures, optional flight battery data failures, retirement or restoration failures, and recoverable persistence issues without exposing pilot-specific battery details, cell readings, condition observations, measured capacity values, mAh used, or ending voltage.
- **Privacy / Data Sensitivity**: Battery identifiers, names, brands, capacity, connector, IR readings, condition observations, measured capacity values, ending voltage, lifecycle status, health classifications, and flight usage relationships are pilot-specific operational data. They must remain local-first, sync only through the pilot's iCloud account for cross-device continuity, and must not be shared outside that account except through explicit pilot action.
- **HIG / Platform Alignment**: Battery Tracker must follow native iOS navigation, list, detail, edit, numeric entry, confirmation, feedback, health status, chart, and accessibility conventions. IR and capacity guidance must be advisory and understandable, avoiding alarmist language while making potential flight risk visible before the pilot selects a pack. Charts must remain useful with large text, VoiceOver, and non-visual summaries.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A pilot can create a new battery with required pack details in under 2 minutes during validation.
- **SC-002**: In validation scenarios covering each supported chemistry, connector, and cell configuration from 1S through 8S, saved battery records persist with 100% accuracy after relaunch.
- **SC-003**: A pilot can manually record a valid charged-battery IR check in milliohms for batteries from 1S through 8S in under 90 seconds per battery during validation after charger readings are available.
- **SC-004**: In validation scenarios covering missing, extra, non-numeric, negative, zero, and valid milliohm IR readings, the manual IR entry flow accepts or rejects entries according to the specified rules with 100% accuracy.
- **SC-005**: A pilot can manually record a valid measured capacity check in under 60 seconds during validation after the charger discharge measurement is available.
- **SC-006**: In validation scenarios covering missing, non-numeric, negative, zero, unusually high, and valid measured capacity values, the capacity entry flow accepts or rejects entries according to the specified rules with 100% accuracy.
- **SC-007**: In validation scenarios covering IR-only, capacity-only, and combined IR-plus-capacity maintenance sessions, Battery Tracker saves and displays the correct check history with 100% accuracy and does not change pack health classification based on capacity alone.
- **SC-008**: In validation scenarios covering Healthy, Monitor / demote, Ill health / retire for demanding use, and Retire rules, Battery Tracker shows the expected pack health classification and the reasons that caused it with 100% accuracy.
- **SC-009**: In validation scenarios where an active battery reaches the Retire health classification, Battery Tracker prompts for retirement and preserves active status until the pilot confirms with 100% accuracy.
- **SC-010**: 100% of saved flights created with a Battery Tracker battery continue to identify the same battery after the battery is edited, retired, or restored.
- **SC-011**: In 100% of validation scenarios with active batteries available, a new flight log requires a battery reference and can be saved without optional mAh used or ending voltage.
- **SC-012**: In validation scenarios covering Healthy, Monitor / demote, Ill health / retire for demanding use, and Retire active batteries, each active battery remains selectable for flight logging without an extra health-classification warning.
- **SC-013**: In validation scenarios where optional flight mAh used and ending voltage are provided, Battery Tracker shows those values as flight usage details and does not create or modify IR checks or measured capacity checks.
- **SC-014**: In validation scenarios, create battery, record IR check, record condition observation, record capacity check, review health classification explanation, select battery for a flight, retire battery, and restore battery workflows can each be completed successfully from Battery Tracker without external setup.
- **SC-015**: A returning pilot can open Battery Tracker and see active batteries within 2 seconds in at least 95% of validation runs using up to 300 batteries and 3,000 saved flight references.
- **SC-016**: In 100% of validation scenarios with active batteries available, the intended battery can be selected for a new flight log in under 30 seconds.
- **SC-017**: In validation scenarios with capacity checks recorded at flight counts 0, 5, and 10, the capacity line graph plots 100% of measured capacity values at the correct flight-count positions.
- **SC-018**: In validation scenarios with IR checks recorded in milliohms at flight counts 0, 5, and 10, the IR bar graph plots 100% of cell IR values at the correct flight-count positions with milliohm units.
- **SC-019**: Accessibility validation finds no blocking issues for browsing batteries, reviewing battery details, entering IR readings, entering condition observations, entering capacity checks, understanding health classifications, reading health charts, confirming retirement, restoring batteries, or selecting a battery for a flight with VoiceOver and large text sizes.

## Assumptions

- Battery Tracker is scoped to the current pilot using the app; multi-pilot sharing is out of scope for this feature.
- Same-pilot cross-device sync through iCloud is in scope for the product and will be specified by the dedicated iCloud sync feature.
- The required battery fields follow the provided data model: numeric identifier, name, chemistry, cell configuration, capacity, and connector.
- Battery brand is optional because not every pilot will know or care about the manufacturer.
- The numeric battery identifier represents a physical pack and remains unique across active and retired records to protect flight history and usage tracking.
- Internal resistance readings are recorded, saved, displayed, and charted in milliohms throughout Battery Tracker. The app labels milliohms wherever readings are entered or displayed.
- IR readings cannot be determined from flight logs. They are manually initiated by the pilot and recorded from charger-provided readings while the battery is charged.
- Healthy pack classification means IR cells are close together, interpreted for validation as highest and lowest readings no more than 25% apart, with no adverse performance, temperature, balance, sag, or damage observations.
- Monitor / demote classification means one cell is more than 25% and no more than 50% higher than the pack average, or the pilot records that the pack sags more than usual. The user-facing recommendation is to use only for lower-current loads.
- Ill health / retire for demanding use classification means one cell is more than 50% and less than 100% higher than the average of the other cells, or the pilot records that the pack comes down badly imbalanced after use.
- Retire classification means one cell is at least 2x the average of the other cells, or the pilot records that the pack puffs, gets unusually hot, has large voltage sag, will not stay balanced, or has physical damage.
- When multiple pack health classification rules apply, the most severe classification wins in this order: Retire, Ill health / retire for demanding use, Monitor / demote, Healthy.
- A Retire health classification prompts the pilot to retire the battery but does not automatically change lifecycle status without confirmation.
- Active batteries remain selectable for flight logging without extra health-classification warnings until the pilot retires them.
- A 1S battery cannot have a same-pack cell comparison against other cells, but it can still receive a health classification from condition observations.
- Measured capacity checks are manually initiated by the pilot and record the mAh measured by a charger after the battery has been fully charged and fully drained on the charger.
- Capacity tracking records measured capacity history and comparison against stated capacity; measured capacity alone does not change pack health classification and is not inferred from flight mAh used.
- IR checks and measured capacity checks can be saved from the same maintenance session or as separate entries.
- Capacity charts use line graphs because measured capacity trends are best shown as continuous changes over accumulated battery flights.
- IR charts use bar graphs because per-cell IR readings are best compared as discrete values at each accumulated flight count.
- The chart X axis represents the battery's accumulated saved flight count at the time the health check was recorded. A health check recorded before any saved flights appears at flight count 0.
- The chart Y axis represents measured capacity for capacity charts and IR in milliohms for IR charts.
- Usage tracking is derived from saved flight references. Flight logs require the battery pack used and may optionally record mAh used and ending voltage.
- Optional flight mAh used and ending voltage are usage details only; they do not create IR checks, capacity checks, or health classifications by themselves.
- Manual cycle counting outside flight logging is out of scope except for explicit charger-based measured capacity checks.
- Retiring a battery means removing it from default new-flight selection while preserving historical flight, IR, and measured capacity data. Permanent deletion of battery records is out of scope for this feature.
- Flight logging may be planned or implemented separately; this feature defines the Battery Tracker behavior and reference contract that flight logs rely on.
