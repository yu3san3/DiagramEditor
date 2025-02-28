//
//  DiagramLinesView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/16.
//

import OuDiaKit
import SwiftUI

struct DiagramEntry: Identifiable {
    let id: UUID
    let points: [CGPoint]
    let color: Color
}

struct DiagramLinesView: View {
    let entries: [DiagramEntry]
    let vScale: Int
    let hScale: Int
    let viewWidth: CGFloat

    var body: some View {
        ForEach(entries, id: \.id) { entry in
            DiagramLine(
                points: entry.points,
                vScale: vScale,
                hScale: hScale,
                viewWidth: viewWidth
            )
            .stroke(entry.color)
        }
    }
}

private struct DiagramLine: Shape {
    let points: [CGPoint]
    let vScale: Int
    let hScale: Int
    let viewWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        if points.isEmpty { return path }

        let scaledPoints = points.map { point in
            CGPoint(
                x: point.x * .init(hScale),
                y: point.y * .init(vScale)
            )
        }

        path.move(to: scaledPoints[0])
        var previousPoint = scaledPoints[0]
        for point in scaledPoints {
            if point.x < previousPoint.x {
                path.addLine(
                    to: .init(
                        x: point.x + viewWidth,
                        y: point.y
                    )
                )
                path.move(
                    to: .init(
                        x: previousPoint.x - viewWidth,
                        y: previousPoint.y
                    )
                )
            }

            path.addLine(to: point)
            previousPoint = point
        }

        return path
    }
}

#Preview {
    ScrollView([.vertical, .horizontal]) {
        DiagramLinesView(
            entries: [],
            vScale: 10,
            hScale: 10,
            viewWidth: 100
        )
    }
}
