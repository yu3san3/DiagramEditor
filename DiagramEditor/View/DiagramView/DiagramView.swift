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
    @Binding var isShowKudariDiagram: Bool
    @Binding var isShowNoboriDiagram: Bool

    var body: some View {
        SyncedScrollView {
            ZStack {
                Legend(viewSize: $viewSize)
                if isShowKudariDiagram {
                    DrawDiagram(houkou: .kudari, diaNum: diaNum, viewSize: $viewSize)
                }
                if isShowNoboriDiagram {
                    DrawDiagram(houkou: .nobori, diaNum: diaNum, viewSize: $viewSize)
                }
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

import OuDiaKit

@Observable
final class DiagramViewState {
    private weak var document: DiagramEditorDocument?

    var viewSize: CGSize = .zero

    var distancesBetweenStations = [Int]()

    func setup(document: DiagramEditorDocument) {
        self.document = document
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
    let viewSize = Binding.constant( CGSize(width: 3000, height: 500) )
    return DiagramView(diaNum: 0,
                       viewSize: viewSize,
                       isShowKudariDiagram: .constant(true),
                       isShowNoboriDiagram: .constant(true))
        .environmentObject(DiagramEditorDocument())
}
