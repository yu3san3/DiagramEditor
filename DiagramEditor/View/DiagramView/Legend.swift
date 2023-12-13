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
                drawLine(.vertical ,lineWidth: lineWidth)
                Spacer()
                    .frame(width: max(intervalWidth - lineWidth, 0) )
            }
            drawLine(.vertical, lineWidth: lineWidth)
        }
    }

    @ViewBuilder
    private func drawHLines(lineWidth: CGFloat, distances: [Int], scale height: CGFloat) -> some View {
        //Int.maxの際に使用するrunTime
        let maxIntRunTime = 3
        //走行時間の合計を計算
        let runTimeSum = CGFloat( distances.reduce(0) {
            //$1がInt.maxだった場合を考慮。そのまま足すとオーバーフローする。
            $0 + ($1 == Int.max ? maxIntRunTime : $1)
        })
        VStack(spacing: 0) {
            ForEach(Array(distances.enumerated()), id: \.offset) { _, distance in
                // (Viewの高さ / 走行時間の合計) * 走行距離
                //Int.maxの場合は、走行距離にmaxIntRunTimeを使用
                let intervalHeight = (height / runTimeSum) * CGFloat( distance == Int.max ? maxIntRunTime : distance )
                drawLine(.horizontal, lineWidth: lineWidth)
                Spacer()
                    .frame(height: max( intervalHeight - lineWidth, 0) )
            }
            drawLine(.horizontal, lineWidth: lineWidth)
        }
    }

    @ViewBuilder
    private func drawLine(_ direction: Axis.Set, lineWidth: CGFloat) -> some View {
        switch direction {
        case .vertical: //縦線
            VLine()
                .stroke(Color.gray.opacity(0.5), lineWidth: lineWidth)
                .frame(width: lineWidth, height: self.viewSize.height)
        case .horizontal: //横線
            HLine()
                .stroke(Color.gray.opacity(0.5), lineWidth: lineWidth)
                .frame(width: self.viewSize.width, height: lineWidth)
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

#Preview {
    @State var viewSize = CGSize(width: 500, height: 500)
    return ScrollView([.horizontal, .vertical]) {
        Legend(viewSize: $viewSize)
            .environmentObject(DiagramEditorDocument())
    }
}
