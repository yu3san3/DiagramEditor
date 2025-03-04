//
//  DiagramEditorApp.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI

@main
struct DiagramEditorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { DiagramDocument() }) { file in
            TopView()
                .environment(\.document, file.document)
        }
    }
}
