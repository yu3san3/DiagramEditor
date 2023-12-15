//
//  ContentView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: DiagramEditorDocument

    @State private var detailViewStatus: DetailViewStatus = .none

    var body: some View {
        NavigationSplitView {
            SidebarView(detailViewStatus: $detailViewStatus)
        } detail: {
            switch detailViewStatus {
            case .none:
                VStack {
                    Text("選択されていません。")
                    Text("ツールバーから表示する項目を選択")
                        .font(.caption)
                }
            case .eki:
                Text("駅ビュー")
            case .ressyasyubetsu:
                Text("列車種別ビュー")
            case .kudariJikokuhyou(let diaNum):
                TimeTableView(houkou: .kudari, diaNum: diaNum)
                    .padding(3)
            case .noboriJikokuhyou(let diaNum):
                TimeTableView(houkou: .nobori, diaNum: diaNum)
                    .padding(3)
            case .diagram:
                Text("ダイヤグラム")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DiagramEditorDocument())
}
