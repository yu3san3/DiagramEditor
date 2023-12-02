//
//  SyncedScrollView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct SyncedScrollView<Content: View, VSyncedContent: View, HSyncedContent: View, TopLeftCell: View>: View {

    var viewSize: CGSize
    let content: Content
    let verticallySyncedContent: VSyncedContent
    let horizontallySyncedContent: HSyncedContent
    let topLeftCell: TopLeftCell

    init(viewSize: CGSize,
         @ViewBuilder content: () -> Content,
         @ViewBuilder vSyncedContent: () -> VSyncedContent,
         @ViewBuilder hSyncedContent: () -> HSyncedContent,
         @ViewBuilder topLeftCell: () -> TopLeftCell
    ) {
        self.viewSize = viewSize
        self.content = content()
        self.verticallySyncedContent = vSyncedContent()
        self.horizontallySyncedContent = hSyncedContent()
        self.topLeftCell = topLeftCell()
    }

    @State private var offset = CGPoint(x: 0, y: 0)

    @State private var contentSize: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topLeading) {
            contentView
            observableScrollView
        }
    }
}

private extension SyncedScrollView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing: 0) {
                topLeftCell

                ScrollView(.horizontal) {
                    horizontallySyncedContent
                        .offset(x: -offset.x)
                }
                .disabled(true)
            }

            HStack(alignment: .top, spacing: 0) {
                ScrollView {
                    verticallySyncedContent
                        .offset(y: -offset.y)
                }
                .disabled(true)

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
            Color.gray.opacity(0.5)
                .frame(width: viewSize.width, height: viewSize.height)
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ObservableViewOffsetKey.self,
                                    value: CGPoint(x: -geometry.frame(in: .named("scroll")).origin.x, y: -geometry.frame(in: .named("scroll")).origin.y))
                })
                .onPreferenceChange(ObservableViewOffsetKey.self) { value in
                    print(value)
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

struct SyncedScrollView_Previews: PreviewProvider {
    static let tableWidth: CGFloat = 20
    static let tableHeight: CGFloat = 20
    static let cellCount: Int = 20

    static var previews: some View {
        SyncedScrollView(viewSize: CGSize(width: Int(tableWidth)*cellCount, height: Int(tableHeight)*cellCount)) {
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
        } topLeftCell: {
            Text("R:\(0)\nC:\(0)")
                .frame(width: tableWidth, height: tableHeight)
                .background(.blue)
        }
    }
}
