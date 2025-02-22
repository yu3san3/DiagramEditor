//
//  TimeTableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import OuDiaKit
import SwiftUI

struct TimeTableView: View {
    let trains: [Train]
    let direction: TrainDirection

    var body: some View {
        SyncedScrollView {
            TrainSchedulesTimetableView(trains: trains)
        } vSyncedContent: {
            StationsTimetableView(direction: direction)
                .frame(width: Const.Timetable.stationWidth)
        } hSyncedContent: {
            TrainInfosTimetableView(trains: trains)
                .frame(
                    height: Const.Timetable.timetableHeight * 2 + Const.Timetable.trainNameHeight
                )
        } topLeftContent: {
            TopLeftCell()
                .frame(width: Const.Timetable.stationWidth)
        }
    }

    private struct TopLeftCell: View {
        var body: some View {
            VStack(spacing: 0) {
                Group {
                    Group {
                        Text("列車番号")

                        Text("列車種別")
                    }
                    .frame(
                        width: Const.Timetable.stationWidth,
                        height: Const.Timetable.timetableHeight
                    )

                    VStack {
                        VText("列車名")
                            .padding(3)

                        Spacer()
                    }
                    .frame(
                        width: Const.Timetable.stationWidth,
                        height: Const.Timetable.trainNameHeight
                    )
                }
                .font(.caption)
                .border(Const.Timetable.topLeftCellColor)
            }
        }
    }
}

#Preview {
    let route = OuDiaDiagram.sample.route

    TimeTableView(trains: route.timetables[0].down.trains, direction: .down)
}
