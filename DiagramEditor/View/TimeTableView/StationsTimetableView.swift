//
//  StationsTimetableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import OuDiaKit
import SwiftUI

struct StationsTimetableView: View {
    @Environment(DiagramEditorDocument.self) private var document

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
                VText("Remark")
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
    let direction: TrainDirection

    var body: some View {
        HStack {
            Text(station.name)
                .padding(2)

            Spacer()

            ForEach(
                station.arrDepTextForTimetable(for: direction),
                id: \.key
            ) { arrDepText in
                VStack(spacing: 2) {
                    Text(String(localized: arrDepText))
                        .padding(2)
                }
            }
        }
        .font(.caption)
        .frame(
            width: Const.Timetable.stationWidth,
            height: Const.Timetable.timetableHeight
        )
        .border(Const.Timetable.stationColor)
    }
}

#Preview {
    ScrollView {
        StationsTimetableView(direction: .up)
    }
}
