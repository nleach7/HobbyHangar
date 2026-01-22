//
//  HobbyHangarUITests.swift
//  HobbyHangarUITests
//
//  Created by Nick Leach on 1/15/26.
//

import XCTest

final class HobbyHangarUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testTabsShowAndNavigateToStubScreens() throws {
        let app = XCUIApplication()
        app.launch()

        // Default tab: Logbook
        XCTAssertTrue(app.staticTexts["Logbook"].waitForExistence(timeout: 2))

        // Hangar tab
        openTab(named: "Hangar", in: app)
        XCTAssertTrue(app.staticTexts["Hangar"].waitForExistence(timeout: 2))

        // Batteries tab (tab label), screen label is "Battery Tracker"
        openTab(named: "Batteries", in: app)
        XCTAssertTrue(app.staticTexts["Battery Tracker"].waitForExistence(timeout: 2))

        // Pilot Profile tab
        openTab(named: "Pilot Profile", in: app)
        XCTAssertTrue(app.staticTexts["Pilot Profile"].waitForExistence(timeout: 2))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

// MARK: - Helpers
private extension HobbyHangarUITests {
    func openTab(named tabName: String, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        let tabButton = app.tabBars.buttons[tabName]
        XCTAssertTrue(tabButton.waitForExistence(timeout: 2), "Missing tab '\(tabName)'", file: file, line: line)
        tabButton.tap()
    }
}
