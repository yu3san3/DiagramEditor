//
//  DetailViewStatus.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/03.
//

import Foundation

enum DetailViewStatus: Hashable {
    case none
    case eki
    case ressyasyubetsu
    case kudariJikokuhyou(diaNum: Int)
    case noboriJikokuhyou(diaNum: Int)
    case diagram
}
