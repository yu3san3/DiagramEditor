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
    /// - Returns: 一意なIDと、時刻表に表示すべき時刻データのタプルを含む配列。
    func timeTableText(timeTypes: [StationTimeType]) -> [(id: UUID, text: String)] {
        timeTypes
            .reversed(shouldReverse: direction == .up)
            .zipLongest(schedule)
            .flatMap { timeType, scheduleEntry in
                guard let timeType else { fatalError("timeTypeは仕様上`nil`になってはいけない。") }

                let arrival = (
                    scheduleEntry?.$arrival.id ?? UUID(),
                    scheduleEntry?.arrival
                    ?? scheduleEntry?.arrivalStatus.timetableText
                    ?? ArrivalStatus.notOperate.timetableText
                )

                let departure = (
                    scheduleEntry?.$departure.id ?? UUID(),
                    scheduleEntry?.departure
                    ?? scheduleEntry?.arrivalStatus.timetableText
                    ?? ArrivalStatus.notOperate.timetableText
                )

                switch timeType {
                case .departure:
                    return [departure]
                case .arrivalDeparture:
                    return [arrival, departure]
                case .downArrival, .upArrival:
                    let isDownArrival = timeType == .downArrival
                    let isTrainDownDirection = direction == .down

                    // 駅が下り着で下り列車、もしくは駅が上り着で上り列車の場合には、着時刻を使用
                    let shouldUseArrival = (isDownArrival && isTrainDownDirection) || (!isDownArrival && !isTrainDownDirection)
                    return [shouldUseArrival ? arrival : departure]
                }
            }
    }

    /// ダイヤグラムで点を打つべき座標を得る。
    ///
    /// - Parameter travelTimes: 各駅間の最短走行時間の配列
    /// - Returns: ダイヤグラムで点を打つべき座標の配列
    func diagramPoints(travelTimes: [Int]) -> [CGPoint] {
        let distanceFromBaseStation = TravelTimeCalculator
            .convertTravelTimesToDistanceFromBaseStation(
                travelTimes: travelTimes,
                direction: .down
            )

        return distanceFromBaseStation
            .zipLongest(schedule)
            .compactMap { distance, scheduleEntry -> [CGPoint]? in
                guard let distance else { fatalError("distanceは仕様上nilになってはならない。") }

                guard
                    scheduleEntry?.arrivalStatus == .pass || scheduleEntry?.arrivalStatus == .stop
                else {
                    return nil
                }

                let arrivalFromMidnight = scheduleEntry?.$arrival.minutesFromMidnight
                let departureFromMidnight = scheduleEntry?.$departure.minutesFromMidnight

                let points = [
                    arrivalFromMidnight.map { CGPoint(x: distance, y: $0) },
                    departureFromMidnight.map { CGPoint(x: distance, y: $0) },
                ].compactMap { $0 }

                return points.isEmpty ? nil : points
            }
            .flatMap { $0 }
    }
}

extension Station {
    /// 駅時刻形式`timeType`と方向`direction`に基づき、時刻表における "着" と "発" の文字列を得る。
    func arrDepTextForTimetable(for direction: TrainDirection) -> [LocalizedStringResource] {
        switch timeType {
        case .departure:
            ["Dep"]
        case .arrivalDeparture:
            ["Arr", "Dep"]
        case .downArrival:
            [direction == .down ? "Arr" : "Dep"]
        case .upArrival:
            [direction == .up ? "Arr" : "Dep"]
        }
    }
}

extension EnvironmentValues {
    var document: DiagramEditorDocument {
        get { self[DocumentKey.self] }
        set { self[DocumentKey.self] = newValue }
    }
}

private struct DocumentKey: EnvironmentKey {
    static var defaultValue = DiagramEditorDocument()
}

extension UTType {
    static var oudiaDocument: UTType {
        UTType(importedAs: "com.takeokm.oudia.text")
    }
}

@Observable
final class DiagramEditorDocument {
    private var diagram: OuDiaDiagram

    var route: Route {
        diagram.route
    }

    var stations: [Station] {
        route.stations
    }

    init(oudiaDiagram diagram: OuDiaDiagram = .sample) {
        self.diagram = diagram
    }

    func trainType(at index: Int) -> TrainType {
        route.trainTypes[index]
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
