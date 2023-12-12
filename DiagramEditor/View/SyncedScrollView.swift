//
//  SyncedScrollView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct SyncedScrollView<Content: View, VSyncedContent: View, HSyncedContent: View, TopLeftContent: View>: View {

    let content: Content
    let verticallySyncedContent: VSyncedContent
    let horizontallySyncedContent: HSyncedContent
    let topLeftContent: TopLeftContent

    init(@ViewBuilder content: () -> Content,
         @ViewBuilder vSyncedContent: () -> VSyncedContent,
         @ViewBuilder hSyncedContent: () -> HSyncedContent,
         @ViewBuilder topLeftContent: () -> TopLeftContent
    ) {
        self.content = content()
        self.verticallySyncedContent = vSyncedContent()
        self.horizontallySyncedContent = hSyncedContent()
        self.topLeftContent = topLeftContent()
    }

    @State private var offset = CGPoint(x: 0, y: 0)

    var viewSize: CGSize {
        CGSize(
            width: vSyncedContentSize.width + contentSize.width,
            height: hSyncedContentSize.height + contentSize.height
        )
    }
    @State private var contentSize: CGSize = .zero
    @State private var vSyncedContentSize: CGSize = .zero
    @State private var hSyncedContentSize: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topLeading) {
            contentView
            observableScrollView
        }
    }
}

private extension SyncedScrollView {
    var contentView: some View {
        HStack(alignment: .top, spacing: 0){
            VStack(spacing: 0) {
                topLeftContent

                ScrollView {
                    verticallySyncedContent
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(key: VSyncedContentKey.self, value: geometry.size)
                            }
                        )
                        .offset(y: -offset.y)
                }
                .disabled(true)
                .onPreferenceChange(VSyncedContentKey.self) { value in
                    self.vSyncedContentSize = value
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal) {
                    horizontallySyncedContent
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(key: HSyncedContentKey.self, value: geometry.size)
                            }
                        )
                        .offset(x: -offset.x)
                }
                .disabled(true)
                .onPreferenceChange(HSyncedContentKey.self) { value in
                    self.hSyncedContentSize = value
                }

                ScrollView([.vertical, .horizontal]) {
                    content
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear.preference(key: ContentSizeKey.self, value: geometry.size)
                            }
                        )
                        .offset(x: -offset.x, y: -offset.y)
                }
                .frame(maxWidth: contentSize.width, maxHeight: contentSize.height) //contentのサイズを制限する
                .disabled(true)
                .onPreferenceChange(ContentSizeKey.self) { value in
                    contentSize = value
                }
            }
        }
    }

    var observableScrollView: some View {
        ScrollView([.vertical, .horizontal]) {
            Group {
#if DEBUG
                Color.gray.opacity(0.5)
#else
                Color.clear
#endif
            }
            .frame(width: viewSize.width, height: viewSize.height)
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: ObservableViewOffsetKey.self,
                                value: CGPoint(x: -geometry.frame(in: .named("scroll")).origin.x, y: -geometry.frame(in: .named("scroll")).origin.y))
            })
            .onPreferenceChange(ObservableViewOffsetKey.self) { value in
                offset = value
            }
        }
        .frame(maxWidth: viewSize.width, maxHeight: viewSize.height) //observableScrollViewのサイズを制限する
        .coordinateSpace(name: "scroll")
    }
}

struct ObservableViewOffsetKey: PreferenceKey {
    static var defaultValue = CGPoint.zero

    typealias Value = CGPoint
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}

struct ContentSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    typealias Value = CGSize
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct VSyncedContentKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    typealias Value = CGSize
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct HSyncedContentKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    typealias Value = CGSize
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

//CGSizeに+演算子を定義
private extension CGSize {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
}

#Preview("with topLeftCell") {
    let tableWidth: CGFloat = 20
    let tableHeight: CGFloat = 20
    let cellCount: Int = 20

    return SyncedScrollView {
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

#Preview("without topLeftCell") {
    let tableWidth: CGFloat = 20
    let tableHeight: CGFloat = 20
    let cellCount: Int = 20

    return SyncedScrollView {
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
        EmptyView()
    }
}
