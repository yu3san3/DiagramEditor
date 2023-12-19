//
//  DiagramEditorDocument.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var oudiaEditDocument: UTType {
        UTType(exportedAs: "com.oudiaEdit.oud")
    }
}

final class DiagramEditorDocument: ReferenceFileDocument {
    @Published var oudData: OudData {
        didSet {
            self.runTimes = getRunTimes(dias: oudData.rosen.dia,
                                        ekiCount: oudData.rosen.eki.count)
        }
    }
    //各駅間の走行時間(≈走行距離)
    var runTimes: [Int] = []
    //走行時間の合計
    var runTimeSum: CGFloat {
        CGFloat( self.runTimes.reduce(0) {
            //$1がInt.maxだった場合を考慮。そのまま足すとオーバーフローする。
            $0 + ($1 != Int.max ? $1 : diagram.maxIntRunTime)
        })
    }

    //MARK: ここで以下のインスタンスを作るのはマズいのでは？
    //      つまり、distanceBetweenEkis諸々をここで持っておくのはマズいかも？
    let timeCalc = TimeCalculation()
    let diagram = Diagram()

    init(oudData: OudData = OudData.mockOudData) {
        self.oudData = oudData
        self.runTimes = getRunTimes(dias: oudData.rosen.dia,
                                                          ekiCount: oudData.rosen.eki.count)
    }

    //開くことができるドキュメントのタイプを設定
    static var readableContentTypes: [UTType] { [.oudiaEditDocument] }

    func snapshot(contentType: UTType) throws -> OudData {
        return oudData
    }

    //ファイルの読み込みを担当
    init(configuration: ReadConfiguration) throws {
        //読み込んだファイル(Shift-JIS Data)をShift-JISでエンコーディング
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .shiftJIS) //stringはUTF-8 String
        else {
            //UTF-8など、Shift-JIS以外の形式で保存されているファイルではエラーとなり開けない
            throw CocoaError(.fileReadCorruptFile)
        }
        self.oudData = OudDataParser.parse(string)
        self.runTimes = getRunTimes(dias: oudData.rosen.dia,
                                                          ekiCount: oudData.rosen.eki.count)
    }
    
    //ファイルの保存を担当
    func fileWrapper(snapshot: OudData, configuration: WriteConfiguration) throws -> FileWrapper {
        let text = OudDataStringifyer.stringify(oudData)
        let data = text.data(using: .shiftJIS)! //UTF-8 StringをShift-JIS Dataに変換
        return .init(regularFileWithContents: data)
    }
}

extension DiagramEditorDocument {
    func getRunTimes(dias: [Dia], ekiCount: Int) -> [Int] {
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
}
