//
//  DiagramView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/08.
//

import SwiftUI

struct DiagramView: View {
    @Environment(\.document) private var document

    let timetable: Timetable
    let diagramViewState: DiagramViewState

    var body: some View {
        SyncedScrollView {
            ZStack {
                DiagramGridLineView(diagramViewState: diagramViewState)

                if diagramViewState.isShowDown {
                    DiagramLinesView(
                        entries: diagramViewState.downDiagramEntries,
                        vScale: diagramViewState.vScale,
                        hScale: diagramViewState.hScale,
                        viewWidth: diagramViewState.viewSize.width
                    )
                }

                if diagramViewState.isShowUp {
                    DiagramLinesView(
                        entries: diagramViewState.upDiagramEntries,
                        vScale: diagramViewState.vScale,
                        hScale: diagramViewState.hScale,
                        viewWidth: diagramViewState.viewSize.width
                    )
                }
            }
        } vSyncedContent: {
            DiagramStationsView(diagramViewState: diagramViewState)
                .frame(width: Const.Diagram.stationWidth)
        } hSyncedContent: {
            DiagramTimesView(scale: diagramViewState.hScale)
                .frame(height: Const.Diagram.timeHight)
        } topLeftContent: {
            EmptyView()
        }
        .onAppear {
            diagramViewState.setup(timetable: timetable, document: document)
        }
    }
}

import OuDiaKit

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

    var totalDistance: Int {
        distancesBetweenStations.reduce(0, +)
    }

    var distancesBetweenStations = [Int]()

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

#Preview {
    DiagramView(
        timetable: OuDiaDiagram.sample.route.timetables[0],
        diagramViewState: .init()
    )
}
