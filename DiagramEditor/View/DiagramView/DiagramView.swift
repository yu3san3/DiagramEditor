//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import SwiftUI

struct DiagramView: View {
    @Environment(DiagramEditorDocument.self) private var document

    let diagramViewState: DiagramViewState

    var body: some View {
        SyncedScrollView {
            ZStack {
                DiagramGridLineView(diagramViewState: diagramViewState)

                if diagramViewState.isShowUp {
                    DrawDiagram()
                }

                if diagramViewState.isShowDown {
                    DrawDiagram()
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
            diagramViewState.setup(document: document)
        }
    }
}

import OuDiaKit

@Observable
final class DiagramViewState {
    weak var document: DiagramEditorDocument?

    var vScale = 10
    var hScale = 10
    var isShowUp = false
    var isShowDown = false

    var viewSize: CGSize {
        CGSize(
            width: CGFloat(Const.Diagram.oneDayMinutes * hScale),
            height: CGFloat(totalDistance * vScale)
        )
    }

    var totalDistance: Int {
        distancesBetweenStations.reduce(0, +)
    }

    var distancesBetweenStations = [Int]()

    func setup(document: DiagramEditorDocument) {
        self.document = document
        updateDistanceBetweenStations()
    }

    func updateDistanceBetweenStations() {
        guard let document else { return }

        Task {
            distancesBetweenStations = await RouteDistancesCalculator
                .calculateDistancesBetweenStations(
                    for: document.route.timetables
                )
        }
    }
}

#Preview {
    DiagramView(diagramViewState: .init())
}
