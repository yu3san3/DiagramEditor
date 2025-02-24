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

private extension Train {
    /// 時刻表に表示すべき時刻データを得る。
    ///
    /// - Parameter timeTypes: 駅の配列から駅時刻形式 (`timeType`) のみを抜き出した配列。列車の方向 (上り・下り) を考慮して逆順にする必要はない。
    /// - Returns: 一意なIDと、時刻表に表示すべき時刻データのタプルを含む配列。
    func timeTableText(timeTypes: [StationTimeType]) -> [(id: UUID, text: String)] {
        timeTypes
            .reversed(shouldReverse: direction == .up)
            .zipLongest(schedule)
            .flatMap { timeType, scheduleEntry in
                guard let timeType else { fatalError("timeTypeは仕様上`nil`になってはいけない。") }

                let arrival = (
                    scheduleEntry?.$arrival.id ?? UUID(),
                    scheduleEntry?.arrival
                    ?? scheduleEntry?.arrivalStatus.timetableText
                    ?? ArrivalStatus.notOperate.timetableText
                )

                let departure = (
                    scheduleEntry?.$departure.id ?? UUID(),
                    scheduleEntry?.departure
                    ?? scheduleEntry?.arrivalStatus.timetableText
                    ?? ArrivalStatus.notOperate.timetableText
                )

                switch timeType {
                case .departure:
                    return [departure]
                case .arrivalDeparture:
                    return [arrival, departure]
                case .downArrival, .upArrival:
                    let isDownArrival = timeType == .downArrival
                    let isTrainDownDirection = direction == .down

                    // 駅が下り着で下り列車、もしくは駅が上り着で上り列車の場合には、着時刻を使用
                    let shouldUseArrival = (isDownArrival && isTrainDownDirection) || (!isDownArrival && !isTrainDownDirection)
                    return [shouldUseArrival ? arrival : departure]
                }
            }
    }
}

private extension ArrivalStatus {
    var timetableText: String {
        switch self {
        case .notOperate: "･･"
        case .stop: "⚪︎"
        case .pass: "ﾚ"
        case .notGoThrough: "||"
        }
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
