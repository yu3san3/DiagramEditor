//
//  SidebarView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/03.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var document: DiagramEditorDocument

    @Binding var detailViewStatus: DetailViewStatus

    @State private var isRosenExpanded = true
    @State private var isDiaExpanded = true
    //FIXME: - ⚠️Diaの要素数が10を超えるとindexがオーバーフローする
    @State private var isDiaContentExpanded: [Bool] = Array(repeating: true, count: 10)

//    init(detailViewStatus: Binding<DetailViewStatus>) {
//        self._detailViewStatus = detailViewStatus
//        self._isDiaContentExpanded = State(initialValue: Array(repeating: true,
//                                                               count: 10)
//        )
//    }

    var body: some View {
        List(selection: $detailViewStatus) {
            DisclosureGroup("路線", isExpanded: $isRosenExpanded) {
                NavigationLink(value: DetailViewStatus.eki) {
                    Text("駅")
                }
                NavigationLink(value: DetailViewStatus.ressyasyubetsu) {
                    Text("列車種別")
                }
                DisclosureGroup("ダイヤ", isExpanded: $isDiaExpanded) {
                    ForEach( Array(document.oudData.rosen.dia.enumerated() ),
                            id: \.1.id
                    ) { index, dia in
                        DisclosureGroup(dia.diaName,
                                        isExpanded: $isDiaContentExpanded[index]
                        ) {
                            NavigationLink(
                                value: DetailViewStatus.kudariJikokuhyou(diaNum: index)
                            ) {
                                Text("下り時刻表")
                            }
                            NavigationLink(
                                value: DetailViewStatus.noboriJikokuhyou(diaNum: index)
                            ) {
                                Text("上り時刻表")
                            }
                            NavigationLink(value: DetailViewStatus.diagram) {
                                Text("ダイヤグラム")
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    SidebarView(detailViewStatus: .constant(.eki))
        .environmentObject(DiagramEditorDocument())
}
