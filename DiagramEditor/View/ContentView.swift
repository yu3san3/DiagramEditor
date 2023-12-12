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
    @State var viewSize = CGSize(width: 1000, height: 500)

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
                    .padding(3)
            case .noboriJikokuhyou(let diaNum):
                TimeTableView(houkou: .nobori, diaNum: diaNum)
                    .padding(3)
            case .diagram:
                DiagramView(viewSize: $viewSize)
                    .padding(3)
            }
        }
        .toolbar {
            ToolbarItemGroup {
                let easeOutAnimation: Animation = .easeOut(duration: 0.3)
                Button {
                    withAnimation(easeOutAnimation) {
                        self.viewSize.width += 100
                    }
                } label: {
                    Label("横幅増", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                }
                Button {
                    withAnimation(easeOutAnimation) {
                        //0以下にならないように三項演算子で制限
                        self.viewSize.width -= self.viewSize.width <= 0 ? 0 : 100
                    }
                } label: {
                    Label("横幅減", systemImage: "arrow.right.and.line.vertical.and.arrow.left")
                }
                Button {
                    withAnimation(easeOutAnimation) {
                        self.viewSize.height += 100
                    }
                } label: {
                    Label("縦幅増", systemImage: "arrow.up.and.line.horizontal.and.arrow.down")
                }
                Button {
                    withAnimation(easeOutAnimation) {
                        //0以下にならないように三項演算子で制限
                        self.viewSize.height -= self.viewSize.height <= 0 ? 0 : 100
                    }
                } label: {
                    Label("縦幅減", systemImage: "arrow.down.and.line.horizontal.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DiagramEditorDocument())
}
