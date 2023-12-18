//
//  CoordinateCalculation.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/16.
//

import Foundation

class CoordinateCalculation {
    func getDistanceBetweenEkis(dias: [Dia], ekiCount: Int) -> [Int] {
        var tempRunTime: [[Int]] = []
        for dia in dias {
            let kudariRunTime = getMinimumRunTime(ressyas: dia.kudari.ressya, ekiCount: ekiCount)
            let noboriRunTime = getMinimumRunTime(ressyas: dia.nobori.ressya, ekiCount: ekiCount).reversed()
            //下りと上りの走行時間を比較し、より小さい方を採用
            tempRunTime.append(
                zip(kudariRunTime, noboriRunTime)
                    .map( { min($0, $1) } )
            )
        }
        //現在の配列(resultArray)と次の配列(nextArray)を取り、それぞれの配列を比較して最小値を取り続ける。
        let result = tempRunTime.reduce(tempRunTime[0]) { resultArray, nextArray in
            zip(resultArray, nextArray).map(min)
        }
        return result
    }

    private func getMinimumRunTime(ressyas: [Ressya], ekiCount: Int) -> [Int] {
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
                if let prevHatsu = previousHatsu,
                   !jikoku.chaku.isEmpty || !jikoku.hatsu.isEmpty {
                    //着時刻のデータがあればそれを使い、なければ発時刻を使う
                    let relevantTime = !jikoku.chaku.isEmpty ? jikoku.chaku : jikoku.hatsu
                    let diff = getTimeDiff(from: prevHatsu, to: relevantTime)
                    //FIXME: - ⚠️diffがnilだとアプリごと落ちる
                    result[i-1] = max(minimumValue, min(diff!, result[i-1]) )
                }
                //発車時刻を保持
                previousHatsu = jikoku.hatsu
            }
        }
        return result
    }

    func getTimeDiff(from firstTime: String, to secondTime: String) -> Int? {
        func getRelevantFormatter(for time: String) -> DateFormatter {
            let formatter = DateFormatter()
            // "123"の場合と"1234"の場合でformatterを使い分ける
            formatter.dateFormat = time.count == 3 ? "Hmm" : "HHmm"
            return formatter
        }

        guard
            let date1 = getRelevantFormatter(for: firstTime).date(from: firstTime),
            let date2 = getRelevantFormatter(for: secondTime).date(from: secondTime)
        else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)

        return components.minute
    }
}
