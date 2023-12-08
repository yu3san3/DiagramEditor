//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import SwiftUI

struct DiagramView: View {
    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            Legend()
        }
    }
}

#Preview {
    DiagramView()
}
