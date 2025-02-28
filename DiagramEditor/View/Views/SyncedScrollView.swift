//
//  SyncedScrollView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct SyncedScrollView<
    Content: View,
    VSyncedContent: View,
    HSyncedContent: View,
    TopLeftContent: View
>: View {
    let content: Content
    let vSyncedContent: VSyncedContent
    let hSyncedContent: HSyncedContent
    let topLeftContent: TopLeftContent

    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder vSyncedContent: () -> VSyncedContent,
        @ViewBuilder hSyncedContent: () -> HSyncedContent,
        @ViewBuilder topLeftContent: () -> TopLeftContent
    ) {
        self.content = content()
        self.vSyncedContent = vSyncedContent()
        self.hSyncedContent = hSyncedContent()
        self.topLeftContent = topLeftContent()
    }

    @State private var vSyncedContentSize: CGSize = .zero
    @State private var hSyncedContentSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var offset: CGPoint = .zero

    var viewSize: CGSize {
        .init(
            width: vSyncedContentSize.width + contentSize.width,
            height: hSyncedContentSize.height + contentSize.height
        )
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // 実際に表示されるコンテンツ
            HStack(alignment: .top, spacing: 0) {
                LeftContent(
                    topLeftContent: topLeftContent,
                    vSyncedContent: vSyncedContent,
                    yOffset: offset.y,
                    vSyncedContentSize: $vSyncedContentSize
                )

                RightContent(
                    hSyncedContent: hSyncedContent,
                    content: content,
                    offset: offset,
                    hSyncedContentSize: $hSyncedContentSize,
                    contentSize: $contentSize
                )
            }

            // 実際には表示されないが、スクロール位置を監視するビュー
            ObservableScrollView(
                viewSize: viewSize,
                offset: $offset
            )
        }
    }

    private struct LeftContent: View {
        let topLeftContent: TopLeftContent
        let vSyncedContent: VSyncedContent
        let yOffset: CGFloat
        @Binding var vSyncedContentSize: CGSize

        var body: some View {
            VStack(spacing: 0) {
                topLeftContent

                ScrollView {
                    vSyncedContent
                        .offset(y: -yOffset)
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: VSyncedContentSizeKey.self,
                                    value: geometry.size
                                )
                            }
                        )
                }
                .disabled(true)
                .onPreferenceChange(VSyncedContentSizeKey.self) { size in
                    vSyncedContentSize = size
                }
            }
        }
    }

    private struct RightContent: View {
        let hSyncedContent: HSyncedContent
        let content: Content
        let offset: CGPoint
        @Binding var hSyncedContentSize: CGSize
        @Binding var contentSize: CGSize

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal) {
                    hSyncedContent
                        .offset(x: -offset.x)
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: HSyncedContentSizeKey.self,
                                    value: geometry.size
                                )
                            }
                        )
                }
                .disabled(true)
                .onPreferenceChange(HSyncedContentSizeKey.self) { size in
                    self.hSyncedContentSize = size
                }

                ScrollView([.vertical, .horizontal]) {
                    content
                        .offset(x: -offset.x, y: -offset.y)
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(
                                    key: ContentSizeKey.self,
                                    value: geometry.size
                                )
                            }
                        )
                }
                .frame(maxWidth: contentSize.width, maxHeight: contentSize.height)
                .disabled(true)
                .onPreferenceChange(ContentSizeKey.self) { size in
                    contentSize = size
                }
            }
        }
    }

    private struct ObservableScrollView: View {
        let viewSize: CGSize
        @Binding var offset: CGPoint

        private let spaceName = "scroll"

        var body: some View {
            ScrollView([.vertical, .horizontal]) {
                Color.clear
                    .frame(width: viewSize.width, height: viewSize.height)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .preference(
                                    key: ObservableViewOffsetKey.self,
                                    value: CGPoint(
                                        x: -geometry.frame(in: .named(spaceName)).origin.x,
                                        y: -geometry.frame(in: .named(spaceName)).origin.y
                                    )
                                )
                        }
                    )
                    .onPreferenceChange(ObservableViewOffsetKey.self) { offset in
                        self.offset = offset
                    }
            }
            .frame(maxWidth: viewSize.width, maxHeight: viewSize.height)
            .coordinateSpace(name: spaceName)
        }
    }
}

private struct VSyncedContentSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct HSyncedContentSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct ContentSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct ObservableViewOffsetKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

// CGSize に+演算子を定義
private extension CGSize {
    static func + (lhs: Self, rhs: Self) -> Self {
        .init(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
}

#Preview("With TopLeftCell") {
    let tableWidth: CGFloat = 20
    let tableHeight: CGFloat = 20
    let cellCount = 20

    SyncedScrollView {
        LazyHStack(spacing: 0) {
            ForEach(1..<cellCount, id: \.self) { column in
                LazyVStack(spacing: 0) {
                    ForEach(1..<cellCount, id: \.self) { row in
                        Text("R:\(row)\nC:\(column)")
                            .frame(width: tableWidth, height: tableHeight)
                    }
                    .background(.green)
                }
            }
        }
    } vSyncedContent: {
        LazyVStack(spacing: 0) {
            ForEach(1..<cellCount, id: \.self) { row in
                Text("R:\(row)\nC:\(0)")
                    .frame(width: tableWidth, height: tableHeight)
            }
            .background(.pink)
        }
        .frame(width: tableWidth)
    } hSyncedContent: {
        LazyHStack(spacing: 0) {
            ForEach(1..<cellCount, id: \.self) { column in
                Text("R:\(0)\nC:\(column)")
                    .frame(width: tableWidth, height: tableHeight)
            }
            .background(.yellow)
        }
        .frame(height: tableHeight)
    } topLeftContent: {
        Text("R:\(0)\nC:\(0)")
            .frame(width: tableWidth, height: tableHeight)
            .background(.blue)
    }
}

#Preview("Without TopLeftCell") {
    let tableWidth: CGFloat = 20
    let tableHeight: CGFloat = 20
    let cellCount = 20

    SyncedScrollView {
        LazyHStack(spacing: 0) {
            ForEach(1..<cellCount, id: \.self) { column in
                LazyVStack(spacing: 0) {
                    ForEach(1..<cellCount, id: \.self) { row in
                        Text("R:\(row)\nC:\(column)")
                            .frame(width: tableWidth, height: tableHeight)
                    }
                    .background(.green)
                }
            }
        }
    } vSyncedContent: {
        LazyVStack(spacing: 0) {
            ForEach(1...cellCount, id: \.self) { row in
                Text("R:\(row)\nC:\(0)")
                    .frame(width: tableWidth, height: tableHeight)
            }
            .background(.pink)
        }
        .frame(width: tableWidth)
    } hSyncedContent: {
        LazyHStack(spacing: 0) {
            ForEach(1..<cellCount, id: \.self) { column in
                Text("R:\(0)\nC:\(column)")
                    .frame(width: tableWidth, height: tableHeight)
            }
            .background(.yellow)
        }
        .frame(height: tableHeight)
    } topLeftContent: {
        EmptyView()
    }
}
