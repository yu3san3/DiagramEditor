//
//  DiagramGridLineView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/07.
//

import OuDiaKit
import SwiftUI

struct DiagramGridLineView: View {
    let diagramViewState: DiagramViewState

    var body: some View {
        ZStack(alignment: .topLeading) {
            VLines(
                scale: diagramViewState.hScale,
                viewHeight: diagramViewState.viewSize.height
            )
            HLines(
                scale: diagramViewState.vScale,
                distancesBetweenStations: diagramViewState.distancesBetweenStations,
                viewWidth: diagramViewState.viewSize.width
            )
        }
    }

    private struct HLines: View {
        let scale: Int
        let distancesBetweenStations: [Int]
        let viewWidth: CGFloat

        var body: some View {
            VStack(spacing: 0) {
                HLine(length: viewWidth)
                    .frame(height: Line.LineWidth.thin.rawValue)

                ForEach(distancesBetweenStations, id: \.self) { distance in
                    VStack(spacing: 0) {
                        Spacer()

                        HLine(length: viewWidth)
                    }
                    .frame(height: .init(distance * scale))
                }
            }
        }
    }

    private struct VLines: View {
        let scale: Int
        let viewHeight: CGFloat

        let lineStyles: [VLine.Style] = {
            (0...Const.Diagram.oneDayMinutes).map {
                VLine.Style(minute: $0)
            }
        }()

        var body: some View {
            LazyHStack(spacing: 0) {
                ForEach(lineStyles) { style in
                    VStack(alignment: .leading) {
                        VLine(
                            style: style,
                            length: viewHeight
                        )
                    }
                    .frame(width: .init(scale))
                }
            }
        }
    }
}

struct HLine: View {
    let length: CGFloat

    var body: some View {
        Line(
            .horizontal,
            width: .thin,
            length: length,
            style: .solid
        )
    }
}

private struct VLine: View {
    struct Style: Identifiable {
        let id: Int
        let width: Line.LineWidth?
        let lineStyle: DiagramLineStyle

        init(minute: Int) {
            id = minute

            width = if minute % 60 == 0 { .thick }
            else if minute % 30 == 0 { .normal }
            else if minute % 10 == 0 { .thin }
            else if minute % 2 == 0 { .extraThin }
            else { nil }

            lineStyle = switch width {
            case .thick, .normal, .none: .solid
            case .thin, .extraThin: .dashed
            }
        }
    }

    let style: Style
    let length: CGFloat

    var body: some View {
        if let width = style.width {
            Line(
                .vertical,
                width: width,
                length: length,
                style: style.lineStyle
            )
        }
    }
}

#Preview {
    ScrollView([.horizontal, .vertical]) {
        DiagramGridLineView(
            diagramViewState: .init()
        )
    }
}
