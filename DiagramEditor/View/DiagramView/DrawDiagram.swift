//
//  DrawDiagram.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/16.
//

import SwiftUI

struct DrawDiagram: View {
    @EnvironmentObject var document: DiagramEditorDocument

    @Binding var viewSize: CGSize

    let coordinateCalc = CoordinateCalculation()

    var body: some View {
        let ressyas = self.document.oudData.rosen.dia[0].kudari.ressya
        ForEach(ressyas) { ressya in
            let points = getPoints(ressya: ressya)
            DiagramLine(points: points)
                .stroke()
        }
    }

    func getPoints(ressya: Ressya) -> [CGPoint] {
        var result: [CGPoint] = []
        let originTime = "000"
        let legendWidth: CGFloat = 1
        //Int.maxの際に使用するrunTime
        let maxIntRunTime = 3
        let distances = self.document.distanceBetweenEkis
        //開始駅からの距離
        var distance = 0
        let height = self.viewSize.height
        //走行時間の合計を計算
        let runTimeSum = CGFloat( distances.reduce(0) {
            //$1がInt.maxだった場合を考慮。そのまま足すとオーバーフローする。
            $0 + ($1 == Int.max ? maxIntRunTime : $1)
        })
        for (index, jikoku) in ressya.ekiJikoku.enumerated() {
            //!!!: - ⚠️Int.maxの時にオーバーフローする
            distance += distances.indices.contains(index-1) ? distances[index-1] : 0
            // (Viewの高さ / 走行時間の合計) * 走行距離
            //Int.maxの場合は、走行距離にmaxIntRunTimeを使用
            let yPoint = (height / runTimeSum) * CGFloat( distance == Int.max ? maxIntRunTime : distance ) + legendWidth
            //時刻データがない場合continue
            if jikoku.chaku.isEmpty && jikoku.hatsu.isEmpty {
                continue
            }
            //着時刻の座標を追加
            if !jikoku.chaku.isEmpty {
                let xPoint = getXPoint(from: originTime, to: jikoku.chaku)
                result.append(
                    CGPoint(x: xPoint,
                            y: Int(yPoint))
                )
            }
            //発時刻の座標を追加
            if !jikoku.hatsu.isEmpty {
                let xPoint = getXPoint(from: originTime, to: jikoku.hatsu)
                result.append(
                    CGPoint(x: xPoint,
                            y: Int(yPoint))
                )
            }
        }
        return result
    }

    func getXPoint(from origin: String, to time: String) -> Int {
        //24時間の分表記
        let totalMinutes: CGFloat = 1440
        //原点からの経過時間(分)
        //FIXME: - ⚠️timeDiffがnilの場合クラッシュする
        let timeFromOrigin = CGFloat(
            coordinateCalc.getTimeDiff(from: origin, to: time)!
        )
        //(原点からの経過時間/0時からの経過時間(分)) * ビューの幅
        //Intで結果を得ようとすると0になってしまうことがあるので、
        //  いったんCGFloatで計算してからIntに変換
        let xPoint = (timeFromOrigin/totalMinutes) * self.viewSize.width
        return Int(xPoint)
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
        DrawDiagram(viewSize: .constant(CGSize(width: 1500, height: 200)))
            .environmentObject(DiagramEditorDocument())
    }
}
