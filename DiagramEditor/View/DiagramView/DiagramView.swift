//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import SwiftUI

struct DiagramView: View {
    let diaNum: Int

    @Binding var viewSize: CGSize

    var body: some View {
        SyncedScrollView {
            ZStack {
                Legend(viewSize: $viewSize)
                DrawDiagram(houkou: .kudari, diaNum: diaNum, viewSize: $viewSize)
                DrawDiagram(houkou: .nobori, diaNum: diaNum, viewSize: $viewSize)
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
    return DiagramView(diaNum: 0, viewSize: viewSize)
        .environmentObject(DiagramEditorDocument())
}
