//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import SwiftUI

struct DiagramView: View {
    @Binding var viewSize: CGSize

    let diagram = Diagram()

    var body: some View {
        SyncedScrollView {
            Legend(viewSize: $viewSize)
        } vSyncedContent: {
            DrawStations(viewSize: $viewSize)
                .frame(width: diagram.ekiWidth)
        } hSyncedContent: {
            DrawTimes(viewSize: $viewSize)
        } topLeftContent: {
            EmptyView()
        }
    }
}

#Preview {
    @State var viewSize = CGSize(width: 1000, height: 500)
    return DiagramView(viewSize: $viewSize)
        .environmentObject(DiagramEditorDocument())
}
