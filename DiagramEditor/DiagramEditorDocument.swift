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

final class DiagramEditorDocument: ReferenceFileDocument {
    @Published var oudData: OudData

    init(oudData: OudData = OudData.mockOudData) {
        self.oudData = oudData
    }

    //開くことができるドキュメントのタイプを設定
    static var readableContentTypes: [UTType] { [.oudiaEditDocument] }

    func snapshot(contentType: UTType) throws -> OudData {
        return oudData
    }

    //ファイルの読み込みを担当
    init(configuration: ReadConfiguration) throws {
        //読み込んだファイル(Shift-JIS Data)をShift-JISでエンコーディング
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .shiftJIS) //stringはUTF-8 String
        else {
            //UTF-8など、Shift-JIS以外の形式で保存されているファイルではエラーとなり開けない
            throw CocoaError(.fileReadCorruptFile)
        }
        self.oudData = OudDataParser.parse(string)
    }
    
    //ファイルの保存を担当
    func fileWrapper(snapshot: OudData, configuration: WriteConfiguration) throws -> FileWrapper {
        let text = OudDataStringifyer.stringify(oudData)
        let data = text.data(using: .shiftJIS)! //UTF-8 StringをShift-JIS Dataに変換
        return .init(regularFileWithContents: data)
    }
}
