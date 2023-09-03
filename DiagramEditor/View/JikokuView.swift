//
//  JikokuView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

struct JikokuView: View {
    let ressyas: [Ressya]
    let ekis: [Eki]

    let table = Table()

    var body: some View {
        LazyHStack(spacing: 0) {
            ForEach(ressyas) { ressya in
                LazyVStack(spacing: 0) {
                    let array = Array( zipLongest(ekis, ressya.ekiJikoku) )
                    ForEach(array, id: \.1?.id) { eki, jikoku in
                        let _ = debugPrint(eki)
                        switch eki?.ekijikokukeisiki {
                        case .hatsuchaku:
                            Text(jikoku?.chaku ?? "nil")
                            Text(jikoku?.hatsu ?? "nil")
                        case .hatsu:
                            Text(jikoku?.hatsu ?? "nil")
                        case .kudariChaku:
                            Text("くだり着")
                        case .noboriChaku:
                            Text("のぼり着")
                        case .none:
                            Text("none")
                        }
                    }
                    .font(.caption)
                    .frame(
                        width: table.columnWidth,
                        height: table.rowHeight
                    )
                    .border(Color.green)
                    VStack { //備考
                        VText(ressya.bikou)
                            .font(.caption)
                            .padding(3)
                        Spacer()
                    }
                    .frame(
                        width: table.columnWidth,
                        height: table.columnHeight*6
                    )
                    .border(Color.yellow)
                }
            }
        }
    }
}

private func zipLongest<T, U>(_ first: [T], _ second: [U]) -> AnyIterator<(T?, U?)> {
    // インデックスとイテレータを初期化する
    var index = 0
    var firstIterator = first.makeIterator()
    var secondIterator = second.makeIterator()

    // イテレータを返すクロージャを定義する
    return AnyIterator {
        // 両方のシーケンスが終了したらnilを返す
        if index >= first.count && index >= second.count {
            return nil
        }
        // インデックスに対応する要素を取得する
        let firstElement = index < first.count ? firstIterator.next() : nil
        let secondElement = index < second.count ? secondIterator.next() : nil
        // インデックスをインクリメントする
        index += 1
        // 要素のペアを返す
        return (firstElement, secondElement)
    }
}

struct JikokuView_Previews: PreviewProvider {
    static var previews: some View {
        JikokuView(ressyas: OudData.mockOudData.rosen.dia[0].kudari.ressya, ekis: OudData.mockOudData.rosen.eki)
        JikokuView(ressyas: OudData.mockOudData.rosen.dia[0].nobori.ressya, ekis: OudData.mockOudData.rosen.eki)
    }
}
