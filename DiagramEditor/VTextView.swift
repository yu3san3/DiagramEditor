//
//  VTextView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

struct VText: View {
    let text: String
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach (Array(text), id: \.self) { str in
                Text(String(str))
            }
        }
    }
}

struct VTextView_Previews: PreviewProvider {
    static var previews: some View {
        VText(text:
"""
こんにちは、世界！
Hello, World!
"""
        )
    }
}
