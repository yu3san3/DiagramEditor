//
//  DrawDiagram.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/16.
//

import OuDiaKit
import SwiftUI

struct DrawDiagram: View {
    var body: some View {
        EmptyView()
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
    ScrollView([.vertical, .horizontal]) {
        DrawDiagram()
    }
}
