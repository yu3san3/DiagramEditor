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
            ForEach(document.oudData.rosen.dia[diaNum].kudari.ressya) { ressya in
                makeRessyaInfoListItem(ressya: ressya)
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
                .border(Color.red)
            //column.syubetsuはInt型
            if document.oudData.rosen.ressyasyubetsu.indices.contains(ressya.syubetsu) {
                Text(document.oudData.rosen.ressyasyubetsu[ressya.syubetsu].ryakusyou)
                    .font(.caption)
                    .frame(
                        width: table.jikokuWidth,
                        height: table.jikokuHeight
                    )
                    .border(Color.red)
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
            .border(Color.red)
        }
    }
}

#Preview {
    RessyaInfoList(houkou: .kudari, diaNum: 0)
        .environmentObject(DiagramEditorDocument())
}
