//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import SwiftUI

struct DiagramView: View {
    @State var viewSize = CGSize(width: 1000, height: 500)

    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            Legend(viewSize: $viewSize)
        }
    }
}

#Preview {
    DiagramView()
        .environmentObject(DiagramEditorDocument())
}
