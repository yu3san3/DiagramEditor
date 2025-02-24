//
//  ContentView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI
import OuDiaKit

struct ContentView: View {
    @EnvironmentObject var document: DiagramEditorDocument

    var diagramViewState = DiagramViewState()
    @State private var detailViewStatus: DetailViewStatus = .none
    @State private var viewSize = CGSize(width: 1000, height: 500)
    @State private var isShowKudariDiagram = true
    @State private var isShowNoboriDiagram = true

    var body: some View {
        NavigationSplitView {
            SidebarView(detailViewStatus: $detailViewStatus)
        } detail: {
            switch detailViewStatus {
            case .none:
                VStack {
                    Text("項目が選択されていません。")
                    Text("ツールバーから表示する項目を選択してください。")
                        .font(.caption)
                }
            case .eki:
                Text("駅ビュー")
            case .ressyasyubetsu:
                Text("列車種別ビュー")
            case .kudariJikokuhyou(let diaNum):
                TimeTableView(
                    trains: OuDiaDiagram.sample.route.timetables[0].down.trains,
                    direction: .down
                )
                .padding(3)
            case .noboriJikokuhyou(let diaNum):
                TimeTableView(
                    trains: OuDiaDiagram.sample.route.timetables[0].up.trains,
                    direction: .up
                )
                .padding(3)
            case .diagram(let diaNum):
                DiagramView(diagramViewState: diagramViewState)
                    .padding(3)
            }
        }
        .toolbar {
            if case .diagram(diaNum: _) = detailViewStatus {
                ToolbarItemGroup {
                    Toggle(isOn: $isShowNoboriDiagram) {
                        Image(systemName: "arrow.up.right")
                    }
                    Toggle(isOn: $isShowKudariDiagram) {
                        Image(systemName: "arrow.down.right")
                    }
                }
                ToolbarItemGroup {
                    let easeOutAnimation: Animation = .easeOut(duration: 0.3)
                    Button {
                        withAnimation(easeOutAnimation) {
                            self.viewSize.width *= 1.5
                        }
                    } label: {
                        Label("横幅増", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                    }
                    Button {
                        withAnimation(easeOutAnimation) {
                            //0以下にならないように三項演算子で制限
                            self.viewSize.width /= self.viewSize.width <= 0 ? 1 : 1.5
                        }
                    } label: {
                        Label("横幅減", systemImage: "arrow.right.and.line.vertical.and.arrow.left")
                    }
                    Button {
                        withAnimation(easeOutAnimation) {
                            self.viewSize.height *= 1.5
                        }
                    } label: {
                        Label("縦幅増", systemImage: "arrow.up.and.line.horizontal.and.arrow.down")
                    }
                    Button {
                        withAnimation(easeOutAnimation) {
                            //0以下にならないように三項演算子で制限
                            self.viewSize.height /= self.viewSize.height <= 0 ? 1 : 1.5
                        }
                    } label: {
                        Label("縦幅減", systemImage: "arrow.down.and.line.horizontal.and.arrow.up")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DiagramEditorDocument())
}
