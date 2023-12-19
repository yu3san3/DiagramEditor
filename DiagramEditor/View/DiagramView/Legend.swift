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
                       runTimesForInterval: document.runTimes,
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
    private func drawHLines(lineWidth: CGFloat, runTimesForInterval runTimes: [Int], scale height: CGFloat) -> some View {
        VStack(spacing: 0) {
            //idをきちんと指定するためにenumeratedを使ってる
            ForEach(Array(runTimes.enumerated()), id: \.offset) { _, runTime in
                // (Viewの高さ / 走行時間の合計) * 走行時間
                //Int.maxの場合は、走行時間にmaxIntRunTimeを使用
                let intervalHeight = (height / self.document.runTimeSum) * CGFloat( runTime == Int.max ? diagram.maxIntRunTime : runTime )
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
