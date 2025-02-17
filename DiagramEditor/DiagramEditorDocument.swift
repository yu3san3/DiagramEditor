//
//  DiagramEditorDocument.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import OuDiaKit
import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    static var oudiaDocument: UTType {
        UTType(importedAs: "com.takeokm.oudia.text")
    }
}

@Observable
final class DiagramEditorDocument {
    var diagram: OuDiaDiagram

    init(oudiaDiagram diagram: OuDiaDiagram = .sample) {
        self.diagram = diagram
    }
}

extension DiagramEditorDocument: ReferenceFileDocument {
    // 開くことができるドキュメントのタイプを設定
    static var readableContentTypes: [UTType] { [.oudiaDocument] }

    // ファイルの読み込み
    convenience init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents,
            let string = String(data: data, encoding: .shiftJIS)
        else {
            // Shift-JIS以外の形式で保存されているファイルではエラーとなり開けない。
            throw CocoaError(.fileReadCorruptFile)
        }

        let diagram = try OuDiaDiagramParser().parse(from: string)

        self.init(oudiaDiagram: diagram)
    }

    // ドキュメントの現在の状態を表すスナップショットを作成
    func snapshot(contentType: UTType) throws -> OuDiaDiagram {
        diagram
    }

    // ファイルの保存
    func fileWrapper(
        snapshot: OuDiaDiagram,
        configuration: WriteConfiguration
    ) throws -> FileWrapper {
        let stringifier = OuDiaDiagramStringifier(fileTypeAppComment: "DiagramEditor v1.0.0-alpha")
        let string = stringifier.stringify(snapshot)

        guard let data = string.data(using: .shiftJIS) else {
            throw CocoaError(.fileWriteFileExists)
        }

        return .init(regularFileWithContents: data)
    }
}
