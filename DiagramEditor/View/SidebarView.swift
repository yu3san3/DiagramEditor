//
//  SidebarView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/03.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var document: DiagramEditorDocument

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
            return AnyView(HStack {
                Image(systemName: content.icon)
                Text(content.name)
            })
        }
    }
}

private extension SidebarView {
    func makeSidebarContents() -> [SidebarContent] {
        var dias: [SidebarContent] = []
        for dia in document.oudData.rosen.dia {
            dias.append(
                SidebarContent(name: dia.diaName, icon: "doc", children: [
                SidebarContent(name: "下り時刻表", icon: "doc", children: nil),
                SidebarContent(name: "上り時刻表", icon: "doc", children: nil),
                SidebarContent(name: "ダイヤグラム", icon: "doc", children: nil),
                ])
            )
        }
        return [SidebarContent(name: "路線", icon: "folder", children: [
            SidebarContent(name: "駅", icon: "doc", children: nil),
            SidebarContent(name: "列車種別", icon: "doc", children: nil),
            SidebarContent(name: "ダイヤ", icon: "folder", children: dias)
        ])]
    }
}

struct SidebarContent: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let children: [SidebarContent]?
}

#Preview {
    SidebarView()
        .environmentObject(DiagramEditorDocument())
}
