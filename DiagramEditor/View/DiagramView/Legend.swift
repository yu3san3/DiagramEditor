//
//  Legend.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/07.
//

import SwiftUI

struct Legend: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<24) { _ in
                drawVLine(interval: 60)
            }
        }
    }

    @ViewBuilder
    func drawVLine(interval: CGFloat) -> some View {
        let lineWidth: CGFloat = 1
        VLine()
            .stroke(Color.gray.opacity(0.5), lineWidth: lineWidth)
            .frame(width: lineWidth, height: 500)
        Spacer()
            .frame(width: interval - lineWidth )
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

#Preview {
    ScrollView([.horizontal, .vertical]) {
        Legend()
    }.frame(width: 320, height: 200)
}
