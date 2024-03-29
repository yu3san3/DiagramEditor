//
//  RessyaInfoList.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct RessyaInfoList: View {
    @EnvironmentObject var document: DiagramEditorDocument

    let houkou: Houkou
    let diaNum: Int

    let table = Table()

    var body: some View {
        LazyHStack(spacing: 0) {
            switch houkou {
            case .kudari:
                ForEach(document.oudData.rosen.dia[diaNum].kudari.ressya) { ressya in
                    makeRessyaInfoListItem(ressya: ressya)
                }
            case .nobori:
                ForEach(document.oudData.rosen.dia[diaNum].nobori.ressya) { ressya in
                    makeRessyaInfoListItem(ressya: ressya)
                }
            }
        }
    }

    private func makeRessyaInfoListItem(ressya: Ressya) -> some View {
        VStack(spacing: 0) {
            Text(ressya.ressyabangou)
                .font(.caption)
                .frame(
                    width: table.jikokuWidth,
                    height: table.jikokuHeight
                )
                .border(table.ressyaInfoListColor)
            //column.syubetsuはInt型
            if document.oudData.rosen.ressyasyubetsu.indices.contains(ressya.syubetsu) {
                Text(document.oudData.rosen.ressyasyubetsu[ressya.syubetsu].ryakusyou)
                    .font(.caption)
                    .frame(
                        width: table.jikokuWidth,
                        height: table.jikokuHeight
                    )
                    .border(table.ressyaInfoListColor)
            } else {
                Text("Index Overflow")
                    .font(.caption)
            }
            VStack {
                VText(ressya.ressyamei)
                    .font(.caption)
                    .padding(3) //ここに数字入れないとなんか表示がおかしくなる
                Spacer()
            }
            .frame(
                width: table.jikokuWidth,
                height: table.ressyameiHeight
            )
            .border(table.ressyaInfoListColor)
        }
    }
}

#Preview {
    ScrollView(.horizontal) {
        RessyaInfoList(houkou: .kudari, diaNum: 0)
            .environmentObject(DiagramEditorDocument())
    }
}
