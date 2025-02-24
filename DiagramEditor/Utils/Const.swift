//
//  Table.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUICore

enum Const {
    enum Timetable {
        static let timetableWidth: CGFloat = 40
        static let timetableHeight: CGFloat = 20
        static let stationWidth: CGFloat = 80
        static let trainNameHeight: CGFloat = 120
        static let remarkHeight: CGFloat = 120

        static let topLeftCellColor = Color.orange
        static let trainInfoColor = Color.red
        static let stationColor = Color.blue
        static let leftRemarkColor = Color.brown
        static let timetableColor = Color.green
        static let remarkColor = Color.yellow
    }

    enum Diagram {
        static let oneDayMinutes = 1440
        static let stationWidth: CGFloat = 70
        static let stationHeight: CGFloat = 20
        static let timeWidth: CGFloat = 20
    }
}
