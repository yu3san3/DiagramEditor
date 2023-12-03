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

    var body: some View {
        List(selection: $detailViewStatus) {
            DisclosureGroup("路線") {
                NavigationLink(value: DetailViewStatus.eki) {
                    Text("駅")
                }
                NavigationLink(value: DetailViewStatus.ressyasyubetsu) {
                    Text("列車種別")
                }
                DisclosureGroup("ダイヤ") {
                    ForEach( Array(document.oudData.rosen.dia.enumerated() ),
                            id: \.1.id
                    ) { index, dia in
                        DisclosureGroup(dia.diaName) {
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
