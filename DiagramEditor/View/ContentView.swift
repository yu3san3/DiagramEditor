//
//  ContentView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: DiagramEditorDocument

    var body: some View {
//        TextEditor(text: $document.text)
        JikokuhyouView(houkou: .kudari,
                       ressya: OudData.mockOudData.rosen.dia[0].kudari.ressya,
                       rosen: OudData.mockOudData.rosen
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(DiagramEditorDocument()))
    }
}
