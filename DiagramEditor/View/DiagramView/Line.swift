//
//  Line.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/14.
//

import SwiftUI

struct Line: View {
    let direction: Axis.Set
    let lineWidth: CGFloat
    var lineStyle: DiagramSenStyle = .jissen
    @Binding var length: CGFloat

    var body: some View {
        switch direction {
        case .vertical: //縦線
            VLine()
                .stroke(Color.gray.opacity(0.5),
                        style: StrokeStyle(lineWidth: lineWidth, dash: lineStyle.value))
                .frame(width: lineWidth, height: length)
        case .horizontal: //横線
            HLine()
                .stroke(Color.gray.opacity(0.5),
                        style: StrokeStyle(lineWidth: lineWidth, dash: lineStyle.value))
                .frame(width: length, height: lineWidth)
        default:
            EmptyView()
        }
    }
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

struct HLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

#Preview("vertical") {
    Line(direction: .vertical, lineWidth: 1, lineStyle: .hasen, length: .constant(50))
        .frame(width: 300, height: 200)
}

#Preview("horizontal") {
    Line(direction: .horizontal, lineWidth: 1, length: .constant(50) )
        .frame(width: 300, height: 200)
}
