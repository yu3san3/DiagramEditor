//
//  DiagramEditorDocument.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var oudiaEditDocument: UTType {
        UTType(exportedAs: "com.oudiaEdit.oud")
    }
}

struct DiagramEditorDocument: FileDocument {
    var text: String

    init(text: String = "Hello, world!") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.oudiaEditDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .shiftJIS) //utf8だったが、本家oudiaで作ったファイルが読み込めない
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .shiftJIS)! //utf8だったが、本家oudiaで作ったファイルが読み込めない
        return .init(regularFileWithContents: data)
    }
}
