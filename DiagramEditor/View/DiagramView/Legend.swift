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
            drawVLines(thickLineWidth: 1.5,
                       normalLineWidth: 1,
                       thinLineWidth: 0.5,
                       times: times,
                       intervalWidth: self.viewSize.width / CGFloat(times) )
            drawHLines(lineWidth: 1,
                       runTimesForInterval: document.runTimes,
                       scale: self.viewSize.height)
        }
    }

    @ViewBuilder
    private func drawVLines(thickLineWidth: CGFloat,
                            normalLineWidth: CGFloat,
                            thinLineWidth: CGFloat,
                            times: Int,
                            intervalWidth: CGFloat
    ) -> some View {
        HStack(spacing: 0) {
            let thickInterval = intervalWidth - thickLineWidth
            let normalInterval = (thickInterval - normalLineWidth)/2
            let thinInterval = (normalInterval - thinLineWidth*2)/3
            ForEach(0..<times, id: \.self) { _ in
                Line(direction: .vertical ,
                     lineWidth: thickLineWidth,
                     length: self.$viewSize.height)
                switch intervalWidth {
                case 0..<20:
                    //30分おきに区切り線
                    generateSpacer(width: normalInterval)
                    Line(direction: .vertical ,
                         lineWidth: normalLineWidth,
                         lineStyle: .jissen,
                         length: self.$viewSize.height)
                    generateSpacer(width: normalInterval)
                default:
                    //10分おきに区切り線
                    generateSpacer(width: thinInterval)
                    ForEach(0..<2) { _ in
                        Line(direction: .vertical ,
                             lineWidth: thinLineWidth,
                             lineStyle: .hasen,
                             length: self.$viewSize.height)
                        generateSpacer(width: thinInterval)
                    }
                    Line(direction: .vertical ,
                         lineWidth: normalLineWidth,
                         lineStyle: .jissen,
                         length: self.$viewSize.height)
                    Spacer()
                        .frame(width: max(thinInterval, 0) )
                    ForEach(0..<2) { _ in
                        Line(direction: .vertical ,
                             lineWidth: thinLineWidth,
                             lineStyle: .hasen,
                             length: self.$viewSize.height)
                        generateSpacer(width: thinInterval)
                    }
                }
            }
            Line(direction: .vertical,
                 lineWidth: thickLineWidth,
                 length: self.$viewSize.height)
        }
    }

    private func generateSpacer(width: CGFloat) -> some View {
        Spacer()
            .frame(width: max(width, 0))
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
    let viewSize = Binding.constant( CGSize(width: 5000, height: 500) )
    return ScrollView([.horizontal, .vertical]) {
        Legend(viewSize: viewSize)
            .environmentObject(DiagramEditorDocument())
    }
}
