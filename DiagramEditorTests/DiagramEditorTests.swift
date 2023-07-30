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

    func testEkiJikokuParser() throws {
        let testJikokuData = ",,,,,,,,,,,,,,1;200,2,2,1;308/310,2,2,2,1;353/355,2,2,2,2,1;457/,3,3,3,3,3,1;459,1;510/512,2,2,1;604/"
        let parsedData = EkiJikoku.parse(testJikokuData)
        print(parsedData)
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
