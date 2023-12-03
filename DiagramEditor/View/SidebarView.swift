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
        List {
            DisclosureGroup("路線") {
                Text("駅")
                    .onTapGesture {
                        detailViewStatus = .eki
                    }
                Text("列車種別")
                    .onTapGesture {
                        detailViewStatus = .ressyasyubetsu
                    }
                DisclosureGroup("ダイヤ") {
                    ForEach(Array(document.oudData.rosen.dia.enumerated()),
                            id: \.1.id
                    ) { index, dia in
                        DisclosureGroup(dia.diaName) {
                            makeDiaListElement(diaNum: index)
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}

private extension SidebarView {
    @ViewBuilder
    func makeDiaListElement(diaNum: Int) -> some View {
        Text("下り時刻表")
            .onTapGesture {
                detailViewStatus = .jikokuhyou(houkou: .kudari, diaNum: diaNum)
            }
        Text("上り時刻表")
            .onTapGesture {
                detailViewStatus = .jikokuhyou(houkou: .nobori, diaNum: diaNum)
            }
        Text("ダイヤグラム")
            .onTapGesture {
                detailViewStatus = .diagram
            }
    }
}

#Preview {
    SidebarView(detailViewStatus: .constant(.eki))
        .environmentObject(DiagramEditorDocument())
}
