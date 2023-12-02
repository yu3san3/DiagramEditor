//
//  TimeTableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct TimeTableView: View {
    @EnvironmentObject var document: DiagramEditorDocument

    let houkou: Houkou
    let diaNum: Int

    let table = Table()

    var body: some View {
        SyncedScrollView(viewSize: calculateTimeTableViewSize(houkou: houkou, diaNum: diaNum)) {
            JikokuView(houkou: houkou, diaNum: diaNum)
        } vSyncedContent: {
            EkiListView(houkou: houkou)
                .frame(width: table.ekiWidth)
        } hSyncedContent: {
            RessyaInfoList(houkou: houkou, diaNum: diaNum)
                .frame(height: table.jikokuHeight*2 + table.ressyameiHeight)
        } topLeftCell: {
            topLeftCell
                .frame(width: table.ekiWidth)
        }
    }
}

private extension TimeTableView {
    var topLeftCell: some View {
        VStack(spacing: 0) {
            Text("列車番号")
                .font(.caption)
                .frame(
                    width: table.ekiWidth,
                    height: table.jikokuHeight
                )
                .border(Color.yellow)
            Text("列車種別")
                .font(.caption)
                .frame(
                    width: table.ekiWidth,
                    height: table.jikokuHeight
                )
                .border(Color.yellow)
            VStack {
                VText("列車名")
                    .font(.caption)
                    .padding(3)
                Spacer()
            }
            .frame(
                width: table.ekiWidth,
                height: table.ressyameiHeight
            )
            .border(Color.yellow)
        }
    }

    func calculateTimeTableViewSize(houkou: Houkou, diaNum: Int) -> CGSize {
        var ressyaCellCount: Int {
            var ressyas: [Ressya] {
                switch houkou {
                case .kudari:
                    document.oudData.rosen.dia[diaNum].kudari.ressya
                case .nobori:
                    document.oudData.rosen.dia[diaNum].nobori.ressya
                }
            }
            return ressyas.count
        }

        var ekiCellCount: Int {
            let ekis: [Eki] = document.oudData.rosen.eki
            var hatsuchakuCount: Int {
                ekis.filter { $0.ekijikokukeisiki == .hatsuchaku }.count
            }
            return ekis.count + hatsuchakuCount
        }

        return CGSize(
            width: Int(table.jikokuWidth) * ressyaCellCount + Int(table.ekiWidth),
            height: Int(table.jikokuHeight)*ekiCellCount + Int(table.jikokuHeight)*2 + Int(table.ressyameiHeight) + Int(table.bikouHeight)
        )
    }
}

#Preview {
    TimeTableView(houkou: .kudari, diaNum: 0)
        .environmentObject(DiagramEditorDocument())
}
