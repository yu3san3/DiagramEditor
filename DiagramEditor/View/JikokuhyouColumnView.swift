//
//  JikokuhyouRowsView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

enum Houkou {
    case kudari
    case nobori
}

struct JikokuhyouRows: View {
    
    let houkou: Houkou
    
    let column: Eki
    let table: Table
    
    var body: some View {
        switch column.ekijikokukeisiki {
        case .hatsu:
            JikokuhyouRowsTemplateView("発")
        case .hatsuchaku:
            HStack {
                Text(column.ekimei)
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
                width: table.rowWidth,
                height: table.rowHeight*2
            )
            .border(Color.blue)
        case .kudariChaku:
            if houkou == .kudari {
                JikokuhyouRowsTemplateView("着")
            }
            if houkou == .nobori {
                JikokuhyouRowsTemplateView("発")
            }
        case .noboriChaku:
            if houkou == .kudari {
                JikokuhyouRowsTemplateView("発")
            }
            if houkou == .nobori {
                JikokuhyouRowsTemplateView("着")
            }
        }
    }
    
    func JikokuhyouRowsTemplateView(_ hatsucakuText: String) -> some View {
        HStack {
            Text(column.ekimei)
                .padding(2)
            Spacer()
            Text(hatsucakuText)
                .padding(2)
        }
        .font(.caption)
        .frame(
            width: table.rowWidth,
            height: table.rowHeight
        )
        .border(Color.blue)
    }
}

struct JikokuhyouRows_Previews: PreviewProvider {
    static var previews: some View {
        let table = Table()
        JikokuhyouRows(houkou: .kudari, column: OudData.mockOudData.rosen.eki[0], table: table)
    }
}
