//
//  TopWindowView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import OuDiaKit
import SwiftUI

struct TopView: View {
    @Environment(\.document) private var document

    @State private var viewStatus: SidebarView.ViewStatus = .none

    private let diagramViewState = DiagramViewState()

    var body: some View {
        NavigationSplitView {
            SidebarView(viewStatus: $viewStatus)
        } detail: {
            switch viewStatus {
            case .none:
                VStack {
                    Text("NoItemsSelected")

                    Text("NoItemsSelectedSubMessage")
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
                DiagramView(
                    timetable: timetable,
                    diagramViewState: diagramViewState
                )
                .padding(3)
            }
        }
        .toolbar {
            if case .diagram = viewStatus {
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
                            "IncreaseWidth",
                            systemImage: "arrow.left.and.line.vertical.and.arrow.right"
                        )
                    }

                    Button {
                        withAnimation(easeOutAnimation) {
                            diagramViewState.hScale = max(1, diagramViewState.hScale / 2)
                        }
                    } label: {
                        Label(
                            "DecreaseWidth",
                            systemImage: "arrow.right.and.line.vertical.and.arrow.left"
                        )
                    }

                    Button {
                        withAnimation(easeOutAnimation) {
                            diagramViewState.vScale *= 2
                        }
                    } label: {
                        Label(
                            "IncreaseHeight",
                            systemImage: "arrow.up.and.line.horizontal.and.arrow.down"
                        )
                    }

                    Button {
                        withAnimation(easeOutAnimation) {
                            diagramViewState.vScale = max(1, diagramViewState.vScale / 2)
                        }
                    } label: {
                        Label(
                            "DecreaseHeight",
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
