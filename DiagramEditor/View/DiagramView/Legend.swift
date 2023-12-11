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
                       intervalWidth: self.viewSize.width / CGFloat(times - 1) )
            drawHLines(lineWidth: 1,
                       runTimes: getMinimumRunTime(),
                       scale: self.viewSize.height)
        }
    }

    @ViewBuilder
    private func drawVLines(lineWidth: CGFloat, times: Int, intervalWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<times-1, id: \.self) { _ in
                drawLine(.vertical ,lineWidth: lineWidth)
                Spacer()
                    .frame(width: intervalWidth - lineWidth )
            }
            drawLine(.vertical, lineWidth: lineWidth)
        }
    }

    @ViewBuilder
    private func drawHLines(lineWidth: CGFloat, runTimes: [Int], scale height: CGFloat) -> some View {
        //走行時間の合計を計算
        let runTimeSum = CGFloat( runTimes.reduce(0) {
            //オーバーフロー対策
            if $1 == Int.max {
                return $0
            }
            return $0 + $1
        })
        VStack(spacing: 0) {
            ForEach(runTimes, id: \.self) { runTime in
                //オーバーフロー対策
                if runTime == Int.max {
                    let _ = print("Int.max")
                    drawLine(.horizontal, lineWidth: lineWidth)
                } else {
                    let intervalHeight = (height / runTimeSum) * CGFloat(runTime)
                    drawLine(.horizontal, lineWidth: lineWidth)
                    Spacer()
                        .frame(height: intervalHeight - lineWidth)
                }
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

    private func getMinimumRunTime() -> [Int] {
        let ekiCount = self.document.oudData.rosen.eki.count
        var result = Array(repeating: Int.max, count: ekiCount - 1)
        let ressyas = self.document.oudData.rosen.dia[0].kudari.ressya
        //駅間0分を防ぐための最小値
        let minimumValue = 1
        for ressya in ressyas {
            var previousHatsu: String? = nil
            for (i, jikoku) in ressya.ekiJikoku.enumerated() {
                //時刻データなし
                if jikoku.chaku.isEmpty && jikoku.hatsu.isEmpty {
                    previousHatsu = nil
                    continue
                }
                //前の駅に停車している、かつ着時刻か発時刻のデータあり
                if let prevHatsu = previousHatsu,
                    !jikoku.chaku.isEmpty || !jikoku.hatsu.isEmpty {
                    //着時刻のデータがあればそれを使い、なければ発時刻を使う
                    let relevantTime = !jikoku.chaku.isEmpty ? jikoku.chaku : jikoku.hatsu
                    let diff = getTimeDiff(from: prevHatsu, to: relevantTime)
                    result[i-1] = max(minimumValue, min(diff ?? Int.max, result[i-1]) )
                }
                //発車時刻を保持
                previousHatsu = jikoku.hatsu
            }
        }
        return result
    }

    private func getTimeDiff(from firstTime: String, to secondTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"

        guard let date1 = dateFormatter.date(from: firstTime),
              let date2 = dateFormatter.date(from: secondTime) else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)

        return components.minute
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
    @State var viewSize = CGSize(width: 1000, height: 500)
    return ScrollView([.horizontal, .vertical]) {
        Legend(viewSize: $viewSize)
            .environmentObject(DiagramEditorDocument())
    }
}
