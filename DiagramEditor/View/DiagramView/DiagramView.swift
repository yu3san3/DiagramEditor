//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import SwiftUI

struct DiagramView: View {
    @Binding var viewSize: CGSize

    var body: some View {
        SyncedScrollView {
            Legend(viewSize: $viewSize)
        } vSyncedContent: {
            DrawStations()
                .frame(width: 50)
        } hSyncedContent: {
            Text("times")
        } topLeftContent: {
            Text("topLeft")
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    @State var viewSize = CGSize(width: 1000, height: 500)
    return DiagramView(viewSize: $viewSize)
        .environmentObject(DiagramEditorDocument())
}
