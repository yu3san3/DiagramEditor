//
//  DiagramEditorTests.swift
//  DiagramEditorTests
//
//  Created by 丹羽雄一朗 on 2023/07/20.
//

import XCTest
@testable import DiagramEditor

final class DiagramEditorTests: XCTestCase {
    let testOudText = OudData.mockOudText
    let testOudData = OudData.mockOudData

    func testOudParser() throws {
        let parsedData = OuDia.parse(testOudText)
        XCTAssertEqual(parsedData, testOudData)

        let stringifiedData = OuDia.stringify(testOudData)
        XCTAssertEqual(testOudText, stringifiedData)
    }

    func testPerformanceOudParse() throws {
        measure {
            let _ = OuDia.parse(testOudText)
        }
    }

    func testPerformanceOudStringify() throws {
        measure {
            let _ = OuDia.stringify(testOudData)
        }
    }
}
