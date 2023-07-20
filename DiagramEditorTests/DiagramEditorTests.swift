//
//  DiagramEditorTests.swift
//  DiagramEditorTests
//
//  Created by 丹羽雄一朗 on 2023/07/20.
//

import XCTest
@testable import DiagramEditor

final class DiagramEditorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOudParser() throws {
        let testOudText = OudData.mockOudText
        let testOudData = OudData.mockOudData

        let parsedData = OuDia.parse(testOudText)
        XCTAssertEqual(parsedData, testOudData)

        let stringifiedData = OuDia.stringify(testOudData)
        XCTAssertEqual(testOudText, stringifiedData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
