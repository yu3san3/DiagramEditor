//
//  Extension.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/07/21.
//

import Foundation

extension Array {
    var lastElement: Element? {
        get {
            return self.last
        }
        set {
            if let newValue = newValue {
                self[self.endIndex - 1] = newValue
            }
        }
    }
}
