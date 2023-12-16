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
    @Published var oudData: OudData {
        didSet {
            self.distanceBetweenEkis = coordinateCalc.getDistanceBetweenEkis(dias: oudData.rosen.dia,
                                                                             ekiCount: oudData.rosen.eki.count)
        }
    }
    var distanceBetweenEkis: [Int] = []

    //MARK: ここ(DiagramEditorDocumentの中)でCoordinateCalculationのインスタンスを作るのはマズいのでは？
    //      つまり、distanceBetweenEkisをここで持っておくのはマズいのでは？
    let coordinateCalc = CoordinateCalculation()

    init(oudData: OudData = OudData.mockOudData) {
        self.oudData = oudData
        self.distanceBetweenEkis = coordinateCalc.getDistanceBetweenEkis(dias: oudData.rosen.dia,
                                                                         ekiCount: oudData.rosen.eki.count)
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
        self.distanceBetweenEkis = coordinateCalc.getDistanceBetweenEkis(dias: oudData.rosen.dia,
                                                                         ekiCount: oudData.rosen.eki.count)
    }
    
    //ファイルの保存を担当
    func fileWrapper(snapshot: OudData, configuration: WriteConfiguration) throws -> FileWrapper {
        let text = OudDataStringifyer.stringify(oudData)
        let data = text.data(using: .shiftJIS)! //UTF-8 StringをShift-JIS Dataに変換
        return .init(regularFileWithContents: data)
    }
}
