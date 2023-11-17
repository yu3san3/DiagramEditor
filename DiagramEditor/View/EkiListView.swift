//
//  EkiListView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

struct EkiListView: View {
    @EnvironmentObject var document: DiagramEditorDocument

    let houkou: Houkou

    let table = Table()

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(document.oudData.rosen.eki) { eki in
                makeEkiListItem(eki: eki)
            }
            bikouCell
        }
    }

    @ViewBuilder
    private func makeEkiListItem(eki: Eki) -> some View {
        switch eki.ekijikokukeisiki {
        case .hatsu:
            makeEkiListTemplateView(eki: eki, hatsuOrChaku: "発")
        case .hatsuchaku:
            HStack {
                Text(eki.ekimei)
                    .padding(2)
                Spacer()
                VStack(spacing: 0) {
                    Text("着")
                        .padding(2)
                    Text("発")
                        .padding(2)
                }
            }
            .font(.caption)
            .frame(
                width: table.ekiWidth,
                height: table.jikokuHeight*2
            )
            .border(Color.blue)
        case .kudariChaku:
            if houkou == .kudari {
                makeEkiListTemplateView(eki: eki, hatsuOrChaku: "着")
            } else if houkou == .nobori {
                makeEkiListTemplateView(eki: eki, hatsuOrChaku: "発")
            }
        case .noboriChaku:
            if houkou == .kudari {
                makeEkiListTemplateView(eki: eki, hatsuOrChaku: "発")
            } else if houkou == .nobori {
                makeEkiListTemplateView(eki: eki, hatsuOrChaku: "着")
            }
        }
    }

    private func makeEkiListTemplateView(eki: Eki, hatsuOrChaku: String) -> some View {
        HStack {
            Text(eki.ekimei)
                .padding(2)
            Spacer()
            Text(hatsuOrChaku)
                .padding(2)
        }
        .font(.caption)
        .frame(
            width: table.ekiWidth,
            height: table.jikokuHeight
        )
        .border(Color.blue)
    }

    var bikouCell: some View {
        VStack {
            VText("備考")
                .font(.caption)
                .padding(3)
            Spacer()
        }
        .frame(
            width: table.ekiWidth,
            height: table.bikouHeight
        )
        .border(Color.yellow)
    }
}

struct StationListView_Previews: PreviewProvider {
    static var previews: some View {
        EkiListView(houkou: .kudari)
            .environmentObject(DiagramEditorDocument())
    }
}
