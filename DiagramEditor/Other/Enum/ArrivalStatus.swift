//
//  ArrivalStatus.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/10/28.
//

import Foundation

enum ArrivalStatus: String {
    case notOperate = "" //運行なし
    case stop = "1" //停車
    case pass = "2" //通過
    case notGoThrough = "3" //経由なし
}
