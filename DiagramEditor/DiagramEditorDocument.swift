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

    static var readableContentTypes: [UTType] { [.oudiaEditDocument] } //開くことができるドキュメントのタイプを設定

    init(configuration: ReadConfiguration) throws { //ファイルの読み込みを担当
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .shiftJIS) //Shift-JIS Stringに変換
        else {
            throw CocoaError(.fileReadCorruptFile) //utf-8など、Shift-JIS以外の形式で保存されているファイルは開けない
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { //ファイルの保存を担当
        let data = text.data(using: .shiftJIS)!
        return .init(regularFileWithContents: data) //Shift-JIS Dataで保存
    }
}
