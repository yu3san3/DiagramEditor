//
//  OuDiaDiagram+Extension.swift
//  DiagramEditor
//
//  Created by NIWA Yuichiro on 2025/02/17.
//

import OuDiaKit
import SwiftUICore

extension OuDiaDiagram {
    static let sample = OuDiaDiagram(
        fileType: "OuDia.1.02",
        route: .init(
            name: "名鉄名古屋本線",
            stations: [
                .init(
                    name: "金山",
                    timeType: .upArrival,
                    scale: .major
                ),
                .init(
                    name: "山王",
                    timeType: .arrivalDeparture,
                    scale: .normal
                ),
                .init(
                    name: "名鉄名古屋",
                    timeType: .downArrival,
                    scale: .major
                )
            ],
            trainTypes: [
                .init(
                    name: "普通",
                    timetableTextColor: Color(oudColorCode: "00000000"),
                    timetableFontIndex: 0,
                    diagramLineColor: Color(oudColorCode: "00000000"),
                    diagramLineStyle: .solid,
                    stopMarkDrawType: "EStopMarkDrawType_DrawOnStop"
                ),
                .init(
                    name: "特別急行",
                    shortName: "特急",
                    timetableTextColor: Color(oudColorCode: "000000FF"),
                    timetableFontIndex: 0,
                    diagramLineColor: Color(oudColorCode: "000000FF"),
                    diagramLineStyle: .solid,
                    stopMarkDrawType: "EStopMarkDrawType_DrawOnStop"
                )
            ],
            timetables: [
                .init(
                    title: "平日",
                    down: .init(
                        trains: [
                            .init(
                                direction: .down,
                                type: 1,
                                number: "307",
                                schedule: [
                                    .init(arrivalStatus: .stop, arrival: "", departure: "1009"),
                                    .init(arrivalStatus: .pass),
                                    .init(arrivalStatus: .stop, arrival: "1014", departure: "")
                                ]
                            ),
                            .init(
                                direction: .down,
                                type: 0,
                                number: "1093",
                                schedule: [
                                    .init(arrivalStatus: .stop, arrival: "", departure: "1011"),
                                    .init(arrivalStatus: .stop, arrival: "1013", departure: "1013"),
                                    .init(arrivalStatus: .stop, arrival: "1016", departure: "")
                                ]
                            )
                        ]
                    ),
                    up: .init(trains: [])
                ),
                .init(
                    title: "休日",
                    down: .init(
                        trains: [
                            .init(
                                direction: .down,
                                type: 1,
                                number: "101",
                                schedule: [
                                    .init(arrivalStatus: .stop, arrival: "", departure: "1004"),
                                    .init(arrivalStatus: .pass),
                                    .init(arrivalStatus: .stop, arrival: "1008", departure: "")
                                ]
                            )
                        ]
                    ),
                    up: .init(
                        trains: [
                            .init(
                                direction: .up,
                                type: 0,
                                number: "100",
                                schedule: [
                                    .init(arrivalStatus: .stop, arrival: "", departure: "1003"),
                                    .init(arrivalStatus: .pass),
                                    .init(arrivalStatus: .stop, arrival: "1006", departure: "")
                                ]
                            )
                        ]
                    )
                )
            ],
            diagramBaseTime: "400",
            diagramDefaultDistance: 60,
            comment: ""
        ),
        displayProperty: .init(
            timetableFonts: [
                "PointTextHeight=9;Facename=ＭＳ ゴシック",
                "PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1",
                "PointTextHeight=9;Facename=ＭＳ ゴシック;Itaric=1",
                "PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1;Itaric=1",
                "PointTextHeight=9;Facename=ＭＳ ゴシック",
                "PointTextHeight=9;Facename=ＭＳ ゴシック",
                "PointTextHeight=9;Facename=ＭＳ ゴシック",
                "PointTextHeight=9;Facename=ＭＳ ゴシック",
            ],
            timetableVerticalFont: "PointTextHeight=9;Facename=@ＭＳ ゴシック",
            diagramStationNameFont: "PointTextHeight=9;Facename=ＭＳ ゴシック",
            diagramTimeFont: "PointTextHeight=9;Facename=ＭＳ ゴシック",
            diagramTrainFont: "PointTextHeight=9;Facename=ＭＳ ゴシック",
            commentFont: "PointTextHeight=9;Facename=ＭＳ ゴシック",
            diagramTextColor: Color(oudColorCode: "00000000"),
            diagramBackgroundColor: Color(oudColorCode: "00FFFFFF"),
            diagramTrainColor: Color(oudColorCode: "00000000"),
            diagramGridLineColor: Color(oudColorCode: "00C0C0C0"),
            stationNameLength: "6",
            timetableTrainWidth: "5"
        ),
        fileTypeAppComment: "OuDia Ver. 1.02.05"
    )
}
