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
            ForEach(makeSidebarContents()) { content in
                sidebarView(content)
            }
        }
        .listStyle(.sidebar)
    }

    func sidebarView(_ content: SidebarContent) -> some View {
        if let children = content.children {
            return AnyView(DisclosureGroup(content.name) {
                ForEach(children) { child in
                    sidebarView(child)
                }
            })
        } else {
            return AnyView(
                HStack {
                    Image(systemName: content.icon)
                    Text(content.name)
                }
                    .onTapGesture {
                        detailViewStatus = content.detailViewStatus ?? .none
                    }
            )
        }
    }
}

private extension SidebarView {
    func makeSidebarContents() -> [SidebarContent] {
        var dias: [SidebarContent] = []
        for (index, dia) in document.oudData.rosen.dia.enumerated() {
            dias.append(
                SidebarContent(name: dia.diaName, icon: "doc", detailViewStatus: nil, children: [
                    SidebarContent(name: "下り時刻表", icon: "doc", detailViewStatus: .jikokuhyou(houkou: .kudari, diaNum: index), children: nil),
                    SidebarContent(name: "上り時刻表", icon: "doc", detailViewStatus: .jikokuhyou(houkou: .nobori, diaNum: index), children: nil),
                    SidebarContent(name: "ダイヤグラム", icon: "doc", detailViewStatus: .diagram, children: nil),
                ])
            )
        }
        return [SidebarContent(name: "路線", icon: "folder", detailViewStatus: nil, children: [
            SidebarContent(name: "駅", icon: "doc", detailViewStatus: .eki, children: nil),
            SidebarContent(name: "列車種別", icon: "doc", detailViewStatus: .ressyasyubetsu, children: nil),
            SidebarContent(name: "ダイヤ", icon: "folder", detailViewStatus: nil, children: dias)
        ])]
    }
}

struct SidebarContent: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let detailViewStatus: DetailViewStatus?
    let children: [SidebarContent]?
}

#Preview {
    SidebarView(detailViewStatus: .constant(.eki))
        .environmentObject(DiagramEditorDocument())
}
