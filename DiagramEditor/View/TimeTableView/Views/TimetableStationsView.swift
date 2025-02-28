//
//  TimetableStationsView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import OuDiaKit
import SwiftUI

struct TimetableStationsView: View {
    @Environment(\.document) private var document

    let direction: TrainDirection

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(document.stations.reversed(shouldReverse: direction == .up)) { station in
                StationView(
                    station: station,
                    direction: direction
                )
            }

            RemarkCell()
        }
    }

    private struct RemarkCell: View {
        var body: some View {
            VStack {
                VText(resource: "Remark")
                    .font(.caption)
                    .padding(3)
                Spacer()
            }
            .frame(
                width: Const.Timetable.stationWidth,
                height: Const.Timetable.remarkHeight
            )
            .border(Const.Timetable.leftRemarkColor)
        }
    }
}

private struct StationView: View {
    let station: Station
    let arrDepTexts: [LocalizedStringResource]

    init(
        station: Station,
        direction: TrainDirection
    ) {
        self.station = station
        self.arrDepTexts = station.arrDepTextsForTimetable(for: direction)
    }

    var body: some View {
        HStack {
            Text(station.name)
                .padding(2)

            Spacer()

            VStack(spacing: 2) {
                ForEach(arrDepTexts, id: \.key) { arrDepText in
                    Text(String(localized: arrDepText))
                        .padding(2)
                }
            }
        }
        .font(.caption)
        .frame(
            width: Const.Timetable.stationWidth,
            height: arrDepTexts.count == 1
            ? Const.Timetable.timetableHeight
            : Const.Timetable.timetableHeight * 2
        )
        .border(Const.Timetable.stationColor)
    }
}

private extension Station {
    /// 駅時刻形式`timeType`と方向`direction`に基づき、時刻表における "着" と "発" の文字列を得る。
    func arrDepTextsForTimetable(for direction: TrainDirection) -> [LocalizedStringResource] {
        switch timeType {
        case .departure:
            ["Dep"]
        case .arrivalDeparture:
            ["Arr", "Dep"]
        case .downArrival:
            [direction == .down ? "Arr" : "Dep"]
        case .upArrival:
            [direction == .up ? "Arr" : "Dep"]
        }
    }
}

#Preview {
    ScrollView {
        TimetableStationsView(direction: .up)
    }
}
