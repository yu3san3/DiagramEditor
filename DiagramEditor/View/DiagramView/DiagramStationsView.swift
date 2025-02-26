//
//  DiagramStationsView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/12.
//

import OuDiaKit
import SwiftUI

struct DiagramStationsView: View {
    let diagramViewState: DiagramViewState

    var body: some View {
        if let document = diagramViewState.document,
           !diagramViewState.distancesBetweenStations.isEmpty
        {
            LazyVStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text(document.stations.first?.name ?? "")
                    Divider()
                }
                .frame(height: Const.Diagram.stationHeight)

                ForEach(document.stations.dropFirst().indices, id: \.self) { index in
                    VStack(spacing: 0) {
                        Text(document.stations[index].name)
                        Divider()
                    }
                    .frame(
                        height: .init(
                            diagramViewState.distancesBetweenStations[index - 1] * diagramViewState.vScale
                        )
                    )
                }
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    DiagramStationsView(
        diagramViewState: .init()
    )
}
