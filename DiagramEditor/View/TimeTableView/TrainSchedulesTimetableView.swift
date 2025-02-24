//
//  TrainSchedulesTimetableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import OuDiaKit
import SwiftUI

struct TrainSchedulesTimetableView: View {
    @Environment(DiagramEditorDocument.self) private var document

    let trains: [Train]

    var body: some View {
        LazyHStack(spacing: 0) {
            ForEach(trains) { train in
                TrainScheduleView(train: train, timeTypes: document.timeTypes)
            }
        }
    }
}

private struct TrainScheduleView: View {
    let train: Train
    let timeTypes: [StationTimeType]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(
                train.timeTableText(timeTypes: timeTypes),
                id: \.id
            ) { _, text in
                Text(text)
                    .font(.caption)
                    .frame(
                        width: Const.Timetable.timetableWidth,
                        height: Const.Timetable.timetableHeight
                    )
                    .border(Const.Timetable.timetableColor)
            }

            RemarkCell(remark: train.remark ?? "")
        }
    }

    private struct RemarkCell: View {
        let remark: String

        var body: some View {
            VStack {
                VText(remark)
                    .font(.caption)
                    .padding(3)

                Spacer()
            }
            .frame(
                width: Const.Timetable.timetableWidth,
                height: Const.Timetable.remarkHeight
            )
            .border(Const.Timetable.remarkColor)
        }
    }
}

private extension DiagramEditorDocument {
    var timeTypes: [StationTimeType] {
        stations.map { $0.timeType }
    }
}

#Preview("下り") {
    let route = OuDiaDiagram.sample.route

    ScrollView([.vertical, .horizontal]) {
        TrainSchedulesTimetableView(trains: route.timetables[0].down.trains)
    }
}

#Preview("上り") {
    let route = OuDiaDiagram.sample.route

    ScrollView([.vertical, .horizontal]) {
        TrainSchedulesTimetableView(trains: route.timetables[0].up.trains)
    }
}
