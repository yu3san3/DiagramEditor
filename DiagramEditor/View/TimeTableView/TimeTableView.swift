//
//  TimeTableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct TimeTableView: View {
    let houkou: Houkou
    let diaNum: Int

    let table = Table()

    var body: some View {
        SyncedScrollView {
            JikokuView(houkou: houkou, diaNum: diaNum)
        } vSyncedContent: {
            EkiListView(houkou: houkou)
                .frame(width: table.ekiWidth)
        } hSyncedContent: {
            RessyaInfoList(houkou: houkou, diaNum: diaNum)
                .frame(height: table.jikokuHeight*2 + table.ressyameiHeight)
        } topLeftContent: {
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
                .border(Color.orange)
            Text("列車種別")
                .font(.caption)
                .frame(
                    width: table.ekiWidth,
                    height: table.jikokuHeight
                )
                .border(Color.orange)
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
            .border(Color.orange)
        }
    }
}

#Preview {
    TimeTableView(houkou: .kudari, diaNum: 0)
        .environmentObject(DiagramEditorDocument())
}
