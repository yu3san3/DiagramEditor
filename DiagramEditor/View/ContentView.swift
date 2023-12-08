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
            case .kudariJikokuhyou(let diaNum):
                TimeTableView(houkou: .kudari, diaNum: diaNum)
            case .noboriJikokuhyou(let diaNum):
                TimeTableView(houkou: .nobori, diaNum: diaNum)
            case .diagram:
                DiagramView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DiagramEditorDocument())
}
