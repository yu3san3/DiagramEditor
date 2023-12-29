//
//  RunTimeManager.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/30.
//

import Foundation

class RunTimeManager {

    //各駅間の走行時間(≈走行距離)
    private(set) var runTimes: [Int] = []
    //走行時間の合計
    private(set) var runTimeSum: CGFloat = 0

    weak var document: DiagramEditorDocument?

    init(document: DiagramEditorDocument) {
        self.document = document
        updateRunTime()
    }

    let timeCalc = TimeCalculation()
    let diagram = Diagram()

    func updateRunTime() {
        guard let document = self.document else { return }
        self.runTimes = computeRunTimes(dias: document.oudData.rosen.dia,
                                    ekiCount: document.oudData.rosen.eki.count)
        self.runTimeSum = calcRunTimeSum(runTimes: self.runTimes)
    }

    private func computeRunTimes(dias: [Dia], ekiCount: Int) -> [Int] {
        var tempResult: [[Int]] = []
        for dia in dias {
            let kudariRunTimes = getMinimumRunTimes(ressyas: dia.kudari.ressya, ekiCount: ekiCount)
            let noboriRunTimes = getMinimumRunTimes(ressyas: dia.nobori.ressya, ekiCount: ekiCount).reversed()
            //下りと上りの走行時間を比較し、より小さい方を採用
            let tempRunTimes = zip(kudariRunTimes, noboriRunTimes).map(min)
            tempResult.append(tempRunTimes)
        }
        //現在の最小値の配列(currentMinimums)と次の配列(nextArray)を比較
        let result = tempResult.reduce(tempResult[0]) { currentMinimums, nextArray in
            zip(currentMinimums, nextArray).map(min)
        }
        return result
    }

    private func getMinimumRunTimes(ressyas: [Ressya], ekiCount: Int) -> [Int] {
        var result = Array(repeating: Int.max, count: ekiCount - 1)
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
                if let previousHatsu = previousHatsu,
                   !jikoku.chaku.isEmpty || !jikoku.hatsu.isEmpty {
                    //着時刻のデータがあればそれを使い、なければ発時刻を使う
                    let relevantTime = !jikoku.chaku.isEmpty ? jikoku.chaku : jikoku.hatsu
                    let diff = timeCalc.getTimeDiff(from: previousHatsu, to: relevantTime)
                    //FIXME: - ⚠️diffがnilだとアプリごと落ちる
                    result[i-1] = max(minimumValue, min(diff!, result[i-1]) )
                }
                //発車時刻を保持
                previousHatsu = jikoku.hatsu
            }
        }
        return result
    }

    private func calcRunTimeSum(runTimes: [Int]) -> CGFloat {
        return CGFloat(
            runTimes.reduce(0) {
                //$1がInt.maxだった場合を考慮。そのまま足すとオーバーフローする。
                $0 + ($1 != Int.max ? $1 : diagram.maxIntRunTime)
            }
        )
    }
}
