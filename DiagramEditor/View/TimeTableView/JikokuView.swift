//
//  JikokuView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

struct JikokuView: View {
    @EnvironmentObject var document: DiagramEditorDocument

    let houkou: Houkou
    let diaNum: Int

    let table = Table()

    var body: some View {
        switch houkou {
        case .kudari:
            LazyVStack(spacing: 0) {
                let ressyas = document.oudData.rosen.dia[diaNum].kudari.ressya
                jikoku(ressyas: ressyas,
                       ekis: document.oudData.rosen.eki)
                bikou(ressyas: ressyas)
            }
        case .nobori:
            LazyVStack(spacing: 0) {
                let ressyas = document.oudData.rosen.dia[diaNum].nobori.ressya
                jikoku(ressyas: ressyas,
                       ekis: document.oudData.rosen.eki.reversed())
                bikou(ressyas: ressyas)
            }
        }
    }

    @ViewBuilder
    func jikoku(ressyas: [Ressya], ekis: [Eki]) -> some View {
        let columnCellCount = document.oudData.rosen.eki.count +  document.oudData.rosen.eki.filter { $0.ekijikokukeisiki == .hatsuchaku }.count
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0),
                            count: columnCellCount)
        LazyHGrid(rows: columns, spacing: 0) {
            ForEach(ressyas) { ressya in
                ForEach( Array(ressya.ekiJikoku.enumerated() ),
                         id: \.element.id
                ) { index, jikoku in
                    let eki = ekis[index]
                    jikokuCell(ekijikokukeisiki: eki.ekijikokukeisiki,
                               jikoku: jikoku,
                               houkou: ressya.houkou)
                }
                .font(.caption)
                .frame(
                    width: table.jikokuWidth,
                    height: table.jikokuHeight
                )
                .border(Color.green)
            }
        }
    }

    func bikou(ressyas: [Ressya]) -> some View {
        LazyHStack(spacing: 0) {
            ForEach(ressyas) { ressya in
                VStack {
                    VText(ressya.bikou)
                        .font(.caption)
                        .padding(3)
                    Spacer()
                }
                .frame(
                    width: table.jikokuWidth,
                    height: table.bikouHeight
                )
                .border(Color.yellow)
            }
        }
    }

    @ViewBuilder
    //MARK: - 上り、下りの両方できちんと表示されるようにしよう
    func jikokuCell(ekijikokukeisiki: Ekijikokukeisiki,
                    jikoku: Jikoku,
                    houkou: Houkou
    ) -> some View {
        switch ekijikokukeisiki {
        case .hatsuchaku:
            switch jikoku.arrivalStatus {
            case .stop:
                Text(jikoku.chaku)
                Text(jikoku.hatsu)
            case .pass:
                Text("ﾚ")
                Text("ﾚ")
            case .notOperate:
                Text("･･")
                Text("･･")
            case .notGoThrough:
                Text("||")
                Text("||")
            }
        case .hatsu:
            Text(jikoku.hatsu)
        case .kudariChaku:
            switch houkou {
            case .kudari:
                switch jikoku.arrivalStatus {
                case .stop:
                    Text(jikoku.chaku)
                case .pass:
                    Text("ﾚ")
                case .notOperate:
                    Text("･･")
                case .notGoThrough:
                    Text("||")
                }
            case .nobori:
                Text(jikoku.hatsu)
            }
        case .noboriChaku:
            switch houkou {
            case .kudari:
                switch jikoku.arrivalStatus {
                case .stop:
                    Text(jikoku.hatsu)
                case .pass:
                    Text("ﾚ")
                case .notOperate:
                    Text("･･")
                case .notGoThrough:
                    Text("||")
                }
            case .nobori:
                Text(jikoku.chaku)
            }
        }
    }
}

#Preview("下り") {
    ScrollView([.vertical, .horizontal]) {
        JikokuView(houkou: .kudari, diaNum: 0)
            .environmentObject(DiagramEditorDocument())
    }
}

#Preview("上り") {
    ScrollView([.vertical, .horizontal]) {
        JikokuView(houkou: .nobori, diaNum: 0)
            .environmentObject(DiagramEditorDocument())
    }
}
