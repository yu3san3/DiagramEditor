//
//  TopWindowView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI
import OuDiaKit

struct TopView: View {
    @Environment(DiagramEditorDocument.self) private var document

    @State private var viewState: SidebarView.ViewState = .none

    private let diagramViewState = DiagramViewState()

    var body: some View {
        NavigationSplitView {
            SidebarView(viewState: $viewState)
        } detail: {
            switch viewState {
            case .none:
                VStack {
                    Text("項目が選択されていません。")
                    Text("ツールバーから表示する項目を選択してください。")
                        .font(.caption)
                }
            case .station:
                Text("駅ビュー")
            case .trainType:
                Text("列車種別ビュー")
            case let .downTimetable(trains):
                TimeTableView(
                    trains: trains,
                    direction: .down
                )
                .padding(3)
            case let .upTimetable(trains):
                TimeTableView(
                    trains: trains,
                    direction: .up
                )
                .padding(3)
            case let .diagram(timetable):
                DiagramView(diagramViewState: diagramViewState)
                    .padding(3)
            }
        }
        .toolbar {
            if case .diagram = viewState {
                ToolbarItemGroup {
                    @Bindable var diagramViewState = diagramViewState

                    Toggle(isOn: $diagramViewState.isShowUp) {
                        Image(systemName: "arrow.up.right")
                    }

                    Toggle(isOn: $diagramViewState.isShowDown) {
                        Image(systemName: "arrow.down.right")
                    }
                }
                ToolbarItemGroup {
                    let easeOutAnimation: Animation = .easeOut(duration: 0.3)

                    Button {
                        withAnimation(easeOutAnimation) {
                            diagramViewState.hScale *= 2
                        }
                    } label: {
                        Label(
                            "横幅増",
                            systemImage: "arrow.left.and.line.vertical.and.arrow.right"
                        )
                    }

                    Button {
                        withAnimation(easeOutAnimation) {
                            diagramViewState.hScale = max(1, diagramViewState.hScale / 2)
                        }
                    } label: {
                        Label(
                            "横幅減",
                            systemImage: "arrow.right.and.line.vertical.and.arrow.left"
                        )
                    }

                    Button {
                        withAnimation(easeOutAnimation) {
                            diagramViewState.vScale *= 2
                        }
                    } label: {
                        Label(
                            "縦幅増",
                            systemImage: "arrow.up.and.line.horizontal.and.arrow.down"
                        )
                    }

                    Button {
                        withAnimation(easeOutAnimation) {
                            diagramViewState.vScale = max(1, diagramViewState.vScale / 2)
                        }
                    } label: {
                        Label(
                            "縦幅減",
                            systemImage: "arrow.down.and.line.horizontal.and.arrow.up"
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    TopView()
        .environment(\.document, .init())
}
