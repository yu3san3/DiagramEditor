//
//  VTextView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

extension View {
    @ViewBuilder
    func VText(_ text: String) -> some View {
        VStack(spacing: 0) {
            //FIXME: - idをselfにしていることで、重複する可能性がある
            ForEach (Array(text), id: \.self) { str in
                Text(String(str))
            }
        }
    }
}
