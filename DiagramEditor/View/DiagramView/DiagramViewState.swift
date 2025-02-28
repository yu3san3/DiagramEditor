//
//  DiagramViewState.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2025/03/01.
//

import OuDiaKit
import SwiftUICore

@Observable
final class DiagramViewState {
    weak var document: DiagramDocument?

    var timetable: Timetable?
    var vScale = 10
    var hScale = 10
    var isShowUp = false
    var isShowDown = false

    var downDiagramEntries: [DiagramEntry] {
        guard let timetable else { return [] }

        return timetable.down.trains.map {
            .init(
                id: $0.id,
                points: $0.diagramPoints(distancesBetweenStations: distancesBetweenStations),
                color: document?.route.trainTypes[$0.typeIndex].diagramLineColor ?? .black
            )
        }
    }

    var upDiagramEntries: [DiagramEntry] {
        guard let timetable else { return [] }

        return timetable.up.trains.map {
            .init(
                id: $0.id,
                points: $0.diagramPoints(distancesBetweenStations: distancesBetweenStations),
                color: document?.route.trainTypes[$0.typeIndex].diagramLineColor ?? .black
            )
        }
    }

    var viewSize: CGSize {
        CGSize(
            width: CGFloat(Const.Diagram.oneDayMinutes * hScale),
            height: CGFloat(totalDistance * vScale)
        )
    }

    var distancesBetweenStations = [Int]()

    private var totalDistance: Int {
        distancesBetweenStations.reduce(0, +)
    }

    func setup(
        timetable: Timetable,
        document: DiagramDocument
    ) {
        self.timetable = timetable
        self.document = document

        updateDistanceBetweenStations()
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

private extension Train {
    /// ダイヤグラムで点を打つべき座標を得る。
    ///
    /// - Parameter distancesBetweenStations: 各駅間の最短走行距離の配列
    /// - Returns: ダイヤグラムで点を打つべき座標の配列
    func diagramPoints(distancesBetweenStations: [Int]) -> [CGPoint] {
        let distanceFromBaseStation = RouteDistancesCalculator.convertToDistancesFromBaseStation(
            from: distancesBetweenStations
        )

        return distanceFromBaseStation
            .reversed(shouldReverse: direction == .up)
            .zipLongest(schedule)
            .compactMap { distance, scheduleEntry -> [CGPoint]? in
                guard let distance else { fatalError("distanceは仕様上nilになってはならない。") }

                guard
                    scheduleEntry?.arrivalStatus == .pass || scheduleEntry?.arrivalStatus == .stop
                else {
                    return nil
                }

                let arrivalFromMidnight = scheduleEntry?.$arrival.minutesFromMidnight
                let departureFromMidnight = scheduleEntry?.$departure.minutesFromMidnight

                let points = [
                    arrivalFromMidnight.map { CGPoint(x: $0, y: distance) },
                    departureFromMidnight.map { CGPoint(x: $0, y: distance) },
                ].compactMap { $0 }

                return points.isEmpty ? nil : points
            }
            .flatMap { $0 }
    }
}
