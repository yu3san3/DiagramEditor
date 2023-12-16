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
            ZStack {
                Legend(viewSize: $viewSize)
                DrawDiagram(viewSize: $viewSize)
            }
        } vSyncedContent: {
            DrawStations(viewSize: $viewSize)
        } hSyncedContent: {
            DrawTimes(viewSize: $viewSize)
        } topLeftContent: {
            EmptyView()
        }
    }
}

#Preview {
    let viewSize = Binding.constant( CGSize(width: 500, height: 500) )
    return DiagramView(viewSize: viewSize)
        .environmentObject(DiagramEditorDocument())
}
