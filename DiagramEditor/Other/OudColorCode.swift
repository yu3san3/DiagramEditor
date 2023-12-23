//
//  OudColorCode.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/24.
//

import SwiftUI

extension Color {
    init(oudColorCode: String) {
        guard oudColorCode.count == 8 else {
            self.init(red: 0, green: 0, blue: 0)
            return
        }

        let redStr = oudColorCode.suffix(2)
        let greenStr = oudColorCode.prefix(6).suffix(2)
        let blueStr = oudColorCode.prefix(4).suffix(2)
        let opacityStr = oudColorCode.prefix(2)

        let red = Double(Int(redStr, radix: 16) ?? 0) / 255
        let green = Double(Int(greenStr, radix: 16) ?? 0) / 255
        let blue = Double(Int(blueStr, radix: 16) ?? 0) / 255
        let _ = Double(Int(opacityStr, radix: 16) ?? 0) / 255

        self.init(red: red, green: green, blue: blue, opacity: 1)
    }
}
