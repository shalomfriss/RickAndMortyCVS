//
//  RickAndMortyUITests.swift
//  RickAndMortyUITests
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import XCTest

final class RickAndMortyUITests: XCTestCase {
    @MainActor
    func testSearchForBill() throws {
        let app = XCUIApplication()
        app.activate()
        app.searchFields["Rick"].firstMatch.tap()
        app.searchFields["Rick"].firstMatch.typeText("B")
        app.searchFields["Rick"].firstMatch.typeText("i")
        app.searchFields["Rick"].firstMatch.typeText("l")
        app.searchFields["Rick"].firstMatch.typeText("l")
        sleep(1)

        let cells = app.collectionViews["Search"].cells.count
        XCTAssertEqual(cells, 2)
    }
}
