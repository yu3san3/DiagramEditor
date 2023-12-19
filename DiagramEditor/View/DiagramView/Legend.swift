//
//  Legend.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/07.
//

import SwiftUI

struct Legend: View {
    @EnvironmentObject var document: DiagramEditorDocument

    @Binding var viewSize: CGSize
    let times = 24

    let diagram = Diagram()

    var body: some View {
        ZStack(alignment: .topLeading) {
            drawVLines(lineWidth: 1,
                       times: times,
                       intervalWidth: self.viewSize.width / CGFloat(times) )
            drawHLines(lineWidth: 1,
                       distances: document.distanceBetweenEkis,
                       scale: self.viewSize.height)
        }
    }

    @ViewBuilder
    private func drawVLines(lineWidth: CGFloat, times: Int, intervalWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<times, id: \.self) { _ in
                Line(direction: .vertical ,
                     lineWidth: lineWidth,
                     length: self.$viewSize.height)
                Spacer()
                    .frame(width: max(intervalWidth - lineWidth, 0) )
            }
            Line(direction: .vertical,
                 lineWidth: lineWidth,
                 length: self.$viewSize.height)
        }
    }

    @ViewBuilder
    private func drawHLines(lineWidth: CGFloat, distances: [Int], scale height: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(distances.enumerated()), id: \.offset) { _, distance in
                // (Viewの高さ / 走行時間の合計) * 走行距離
                //Int.maxの場合は、走行距離にmaxIntRunTimeを使用
                let intervalHeight = (height / self.document.runTimeSum) * CGFloat( distance == Int.max ? self.diagram.maxIntRunTime : distance )
                Line(direction: .horizontal,
                     lineWidth: lineWidth,
                     length: self.$viewSize.width)
                Spacer()
                    .frame(height: max( intervalHeight - lineWidth, 0) )
            }
            Line(direction: .horizontal,
                 lineWidth: lineWidth,
                 length: self.$viewSize.width)
        }
    }

    
}

#Preview {
    let viewSize = Binding.constant( CGSize(width: 500, height: 500) )
    return ScrollView([.horizontal, .vertical]) {
        Legend(viewSize: viewSize)
            .environmentObject(DiagramEditorDocument())
    }
}
