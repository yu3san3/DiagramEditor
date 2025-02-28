//
//  Line.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/14.
//

import OuDiaKit
import SwiftUI

struct Line: View {
    enum LineAxis {
        case vertical
        case horizontal
    }

    enum LineWidth: CGFloat {
        case thick = 2.0
        case normal = 1.5
        case thin = 1.2
        case extraThin = 0.5
    }

    let axis: LineAxis
    let width: LineWidth
    let length: CGFloat
    let style: DiagramLineStyle
    let color: Color

    init(
        _ axis: LineAxis,
        width: LineWidth,
        length: CGFloat,
        style: DiagramLineStyle,
        color: Color = .gray.opacity(0.5)
    ) {
        self.axis = axis
        self.width = width
        self.length = length
        self.style = style
        self.color = color
    }

    var body: some View {
        LineShape(axis: axis)
            .stroke(
                color,
                style: StrokeStyle(
                    lineWidth: width.rawValue,
                    dash: style.dash
                )
            )
            .frame(
                width: axis == .horizontal ? length : width.rawValue,
                height: axis == .vertical ? length : width.rawValue
            )
    }
}

private struct LineShape: Shape {
    let axis: Line.LineAxis

    func path(in rect: CGRect) -> Path {
        var path = Path()
        switch axis {
        case .vertical:
            path.move(to: .init(x: rect.midX, y: rect.minY))
            path.addLine(to: .init(x: rect.midX, y: rect.maxY))
        case .horizontal:
            path.move(to: .init(x: rect.minX, y: rect.midY))
            path.addLine(to: .init(x: rect.maxX, y: rect.midY))
        }
        return path
    }
}

#Preview("vertical") {
    Line(
        .vertical,
        width: .normal,
        length: 50,
        style: .solid
    )
    .frame(width: 300, height: 200)
}

#Preview("horizontal") {
    Line(
        .horizontal,
        width: .normal,
        length: 50,
        style: .dashed
    )
    .frame(width: 300, height: 200)
}
