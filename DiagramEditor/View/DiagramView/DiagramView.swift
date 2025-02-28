//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import OuDiaKit
import SwiftUI

struct DiagramView: View {
    @Environment(\.document) private var document

    let timetable: Timetable
    let diagramViewState: DiagramViewState

    var body: some View {
        SyncedScrollView {
            ZStack {
                DiagramGridLineView(diagramViewState: diagramViewState)

                if diagramViewState.isShowDown {
                    DiagramLinesView(
                        entries: diagramViewState.downDiagramEntries,
                        vScale: diagramViewState.vScale,
                        hScale: diagramViewState.hScale,
                        viewWidth: diagramViewState.viewSize.width
                    )
                }

                if diagramViewState.isShowUp {
                    DiagramLinesView(
                        entries: diagramViewState.upDiagramEntries,
                        vScale: diagramViewState.vScale,
                        hScale: diagramViewState.hScale,
                        viewWidth: diagramViewState.viewSize.width
                    )
                }
            }
        } vSyncedContent: {
            DiagramStationsView(diagramViewState: diagramViewState)
                .frame(width: Const.Diagram.stationWidth)
        } hSyncedContent: {
            DiagramTimesView(scale: diagramViewState.hScale)
                .frame(height: Const.Diagram.timeHight)
        } topLeftContent: {
            EmptyView()
        }
        .onAppear {
            diagramViewState.setup(timetable: timetable, document: document)
        }
    }
}

#Preview {
    DiagramView(
        timetable: OuDiaDiagram.sample.route.timetables[0],
        diagramViewState: .init()
    )
}
