//
//  DiagramEditorDocument.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2022/12/03.
//

import OuDiaKit
import UniformTypeIdentifiers
import SwiftUI

struct ZipLongestSequence<Sequence1: Sequence, Sequence2: Sequence>: Sequence, IteratorProtocol {
    private var sequence1Iterator: Sequence1.Iterator
    private var sequence2Iterator: Sequence2.Iterator

    init(_ sequence1: Sequence1, _ sequence2: Sequence2) {
        self.sequence1Iterator = sequence1.makeIterator()
        self.sequence2Iterator = sequence2.makeIterator()
    }

    mutating func next() -> (Sequence1.Element?, Sequence2.Element?)? {
        let sequence1Value = sequence1Iterator.next()
        let sequence2Value = sequence2Iterator.next()
        return (sequence1Value == nil && sequence2Value == nil) ? nil : (sequence1Value, sequence2Value)
    }
}

extension Sequence {
    func zipLongest<S: Sequence>(_ other: S) -> ZipLongestSequence<Self, S> {
        ZipLongestSequence(self, other)
    }
}

extension ArrivalStatus {
    var timetableText: String {
        switch self {
        case .notOperate: "･･"
        case .stop: "⚪︎"
        case .pass: "ﾚ"
        case .notGoThrough: "||"
        }
    }
}

extension Train {
    /// 時刻表に表示すべき時刻データを得る。
    ///
    /// - Parameter timeTypes: 駅の配列から駅時刻形式 (`timeType`) のみを抜き出した配列。列車の方向 (上り・下り) を考慮して逆順にする必要はない。
    /// - Returns: 時刻表に表示すべき時刻データの配列。
    func timeTableText(timeTypes: [StationTimeType]) -> [String] {
        timeTypes
            .reversed(shouldReverse: direction == .up)
            .zipLongest(schedule)
            .flatMap { timeType, scheduleEntry in
                guard let timeType else { fatalError("timeTypeは仕様上`nil`になってはいけない。") }

                let arrivalText = scheduleEntry?.arrival
                ?? scheduleEntry?.arrivalStatus.timetableText
                ?? ArrivalStatus.notOperate.timetableText

                let departureText = scheduleEntry?.departure
                ?? scheduleEntry?.arrivalStatus.timetableText
                ?? ArrivalStatus.notOperate.timetableText

                switch timeType {
                case .departure:
                    return [departureText]
                case .arrivalDeparture:
                    return [arrivalText, departureText]
                case .downArrival, .upArrival:
                    let isDownArrival = timeType == .downArrival
                    let isTrainDownDirection = direction == .down

                    // 駅が下り着で下り列車、もしくは駅が上り着で上り列車の場合には、着時刻を使用
                    let shouldUseArrival = (isDownArrival && isTrainDownDirection) || (!isDownArrival && !isTrainDownDirection)
                    return [shouldUseArrival ? arrivalText : departureText]
                }
            }
    }
}

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
