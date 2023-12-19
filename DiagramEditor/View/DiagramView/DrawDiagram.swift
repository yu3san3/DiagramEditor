//
//  DrawDiagram.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/16.
//

import SwiftUI

struct DrawDiagram: View {
    @EnvironmentObject var document: DiagramEditorDocument

    let houkou: Houkou
    let diaNum: Int
    @Binding var viewSize: CGSize

    let timeCalc = TimeCalculation()
    let diagram = Diagram()

    var body: some View {
        switch houkou {
        case .kudari:
            drawDiagram(ressyas: self.document.oudData.rosen.dia[diaNum].kudari.ressya)
        case .nobori:
            drawDiagram(ressyas: self.document.oudData.rosen.dia[diaNum].nobori.ressya)
        }
    }

    func drawDiagram(ressyas: [Ressya]) -> some View {
        ForEach(ressyas) { ressya in
            let points = self.getPoints(ressya: ressya)
            DiagramLine(points: points)
                .stroke()
        }
    }

    func getPoints(ressya: Ressya) -> [CGPoint] {
        var result: [CGPoint] = []
        let originTime = "000"
        let runTimes = self.getRunTimes(for: houkou)
        //基点駅からの走行時間
        var runTimeFromBaseStation = 0
        for (index, jikoku) in ressya.ekiJikoku.enumerated() {
            let runTime = runTimes.indices.contains(index-1) ? runTimes[index-1] : 0
            //基点駅から現在処理中の駅までの距離を求めるため、駅間距離を足す。
            //Int.maxの場合は、走行距離にmaxIntRunTimeを使用
            runTimeFromBaseStation += runTime != Int.max ? runTime : diagram.maxIntRunTime
            //時刻データがない場合continue
            if jikoku.chaku.isEmpty && jikoku.hatsu.isEmpty {
                continue
            }
            let yPoint = getYPoint(for: houkou,
                                   runTime: runTimeFromBaseStation)
            //着時刻の座標を追加
            if !jikoku.chaku.isEmpty {
                let xPoint = getXPoint(from: originTime, to: jikoku.chaku)
                result.append( CGPoint(x: xPoint, y: yPoint) )
            }
            //発時刻の座標を追加
            if !jikoku.hatsu.isEmpty {
                let xPoint = getXPoint(from: originTime, to: jikoku.hatsu)
                result.append( CGPoint(x: xPoint, y: yPoint) )
            }
        }
        return result
    }

    func getXPoint(from origin: String, to time: String) -> Int {
        //24時間の分表記
        let totalMinutes: CGFloat = 1440
        //原点からの経過時間(分)
        //!!!: - ⚠️timeDiffがnilの場合クラッシュする
        let timeFromOrigin = CGFloat(
            timeCalc.getTimeDiff(from: origin, to: time)!
        )
        //(原点からの経過時間/0時からの経過時間(分)) * ビューの幅
        //Intで結果を得ようとすると0になってしまうことがあるので、
        //  いったんCGFloatで計算してからIntに変換
        let xPoint = (timeFromOrigin/totalMinutes) * self.viewSize.width
        return Int(xPoint)
    }

    func getYPoint(for houkou: Houkou, runTime: Int) -> Int {
        let height = self.viewSize.height
        let legendWidth: CGFloat = 1
        // (Viewの高さ / 走行時間の合計) * 走行距離
        let yPoint = (height / self.document.runTimeSum) * CGFloat(runTime)
        switch houkou {
        case .kudari:
            return Int(yPoint + legendWidth)
        case .nobori:
            //(ビューの高さ - 始点からの位置) + 罫線の幅
            //始点からの位置を終点からの位置に変換するためにheight - yPointをする。
            return Int((height - yPoint) + legendWidth)
        }
    }

    private func getRunTimes(for houkou: Houkou) -> [Int] {
        switch houkou {
        case .kudari:
            return self.document.runTimes
        case .nobori:
            return self.document.runTimes.reversed()
        }
    }
}

struct DiagramLine: Shape {
    var points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard !points.isEmpty else { return path }

        path.move(to: points[0])
        for point in points {
            path.addLine(to: point)
        }

        return path
    }
}


#Preview {
    ScrollView([.vertical, .horizontal]) {
        DrawDiagram(houkou: .kudari,
                    diaNum: 0,
                    viewSize: .constant(CGSize(width: 1500, height: 200)))
            .environmentObject(DiagramEditorDocument())
    }
}
