//
//  DiagramSenStyle.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/10/28.
//

import Foundation

enum DiagramSenStyle: String {
    case jissen = "SenStyle_Jissen"
    case hasen = "SenStyle_Hasen"
    case tensen = "SenStyle_Tensen"
    case ittensasen = "SenStyle_Ittensasen"

    var value: [CGFloat] {
        switch self {
        case .jissen:
            return []
        case .hasen:
            return [5, 2]
        case .tensen:
            return [2, 2]
        case .ittensasen:
            return [5, 2, 2, 2]
        }
    }
}
