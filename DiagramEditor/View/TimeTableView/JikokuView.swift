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
                    jikokuText(ekijikokukeisiki: ekis[index].ekijikokukeisiki,
                               jikoku: jikoku,
                               houkou: houkou)
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

    func jikokuText(ekijikokukeisiki: Ekijikokukeisiki,
                       jikoku: Jikoku,
                       houkou: Houkou
    ) -> AnyView {
        switch jikoku.arrivalStatus {
        case .notOperate:
            if ekijikokukeisiki == .hatsuchaku {
                return AnyView(Group {
                    Text("･･")
                    Text("･･")
                })
            }
            return AnyView(Text("･･"))
        case .notGoThrough:
            if ekijikokukeisiki == .hatsuchaku {
                return AnyView(Group {
                    Text("||")
                    Text("||")
                })
            }
            return AnyView(Text("||"))
        case .stop:
            switch ekijikokukeisiki {
            case .hatsu:
                if jikoku.hatsu.isEmpty {
                    return AnyView(Text("⚪︎"))
                }
                return AnyView(Text(jikoku.hatsu))
            case .hatsuchaku:
                return AnyView(Group {
                    Text(jikoku.chaku.isEmpty ? "⚪︎" : jikoku.chaku)
                    Text(jikoku.hatsu.isEmpty ? "⚪︎" : jikoku.hatsu)
                })
            case .kudariChaku:
                var result: String
                //方向によって場合分け
                result = houkou == .kudari ? jikoku.chaku : jikoku.hatsu
                return AnyView(Text(result.isEmpty ? "⚪︎" : result))
            case .noboriChaku:
                var result: String
                result = houkou == .kudari ? jikoku.hatsu : jikoku.chaku
                return AnyView(Text(result.isEmpty ? "⚪︎" : result))
            }
        case .pass:
            switch ekijikokukeisiki {
            case .hatsu:
                if jikoku.hatsu.isEmpty {
                    return AnyView(Text("ﾚ"))
                }
                return AnyView(Text(jikoku.hatsu))
            case .hatsuchaku:
                return AnyView(Group {
                    Text(jikoku.chaku.isEmpty ? "ﾚ" : jikoku.chaku)
                    Text(jikoku.hatsu.isEmpty ? "ﾚ" : jikoku.hatsu)
                })
            case .kudariChaku:
                var result: String
                //方向によって場合分け
                result = houkou == .kudari ? jikoku.chaku : jikoku.hatsu
                return AnyView(Text(result.isEmpty ? "ﾚ" : result))
            case .noboriChaku:
                var result: String
                result = houkou == .kudari ? jikoku.hatsu : jikoku.chaku
                return AnyView(Text(result.isEmpty ? "ﾚ" : result))
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
