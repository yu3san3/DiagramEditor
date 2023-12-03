//
//  DetailViewStatus.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/03.
//

import Foundation

enum DetailViewStatus {
    case eki
    case ressyasyubetsu
    case jikokuhyou(houkou: Houkou, diaNum: Int)
    case diagram
}
