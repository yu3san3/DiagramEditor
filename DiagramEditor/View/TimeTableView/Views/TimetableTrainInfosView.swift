//
//  TrainInfosTimetableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import OuDiaKit
import SwiftUI

struct TimetableTrainInfosView: View {
    @Environment(\.document) private var document

    let trains: [Train]

    var body: some View {
        LazyHStack(spacing: 0) {
            ForEach(trains) { train in
                TrainInfoView(
                    train: train,
                    trainType: document.trainType(at: train.typeIndex)
                )
            }
        }
    }
}

private struct TrainInfoView: View {
    let train: Train
    let trainType: TrainType

    var body: some View {
        VStack(spacing: 0) {
            Group {
                Group {
                    Text(train.number ?? "")
                    Text(trainType.shortName ?? "")
                }
                .frame(
                    width: Const.Timetable.timetableWidth,
                    height: Const.Timetable.timetableHeight
                )

                VText(train.name ?? "")
                    .frame(
                        width: Const.Timetable.timetableWidth,
                        height: Const.Timetable.trainNameHeight
                    )
            }
            .font(.caption)
            .border(Const.Timetable.trainInfoColor)
        }
    }
}

#Preview {
    let route = OuDiaDiagram.sample.route

    ScrollView(.horizontal) {
        TimetableTrainInfosView(trains: route.timetables[0].down.trains)
    }
}
