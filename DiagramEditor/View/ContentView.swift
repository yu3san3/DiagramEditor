//
//  ContentView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: DiagramEditorDocument

    var body: some View {
        TimeTableView(houkou: .kudari, diaNum: 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DiagramEditorDocument())
    }
}
