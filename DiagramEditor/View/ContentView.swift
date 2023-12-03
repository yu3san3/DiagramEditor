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
                Text("none")
            case .eki:
                Text("駅")
            case .ressyasyubetsu:
                Text("列車種別")
            case .jikokuhyou(let houkou, let diaNum):
                TimeTableView(houkou: houkou, diaNum: diaNum)
            case .diagram:
                Text("ダイヤグラム")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DiagramEditorDocument())
    }
}
