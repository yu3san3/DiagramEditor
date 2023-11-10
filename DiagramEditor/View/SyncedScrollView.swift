//
//  SyncedScrollView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct SyncedScrollView<Content: View, VSyncedContent: View, HSyncedContent: View, TopLeftCell: View>: View {

    let content: Content
    let verticallySyncedContent: VSyncedContent
    let horizontallySyncedContent: HSyncedContent
    let topLeftCell: TopLeftCell

    init(@ViewBuilder content: () -> Content,
         @ViewBuilder vSyncedContent: () -> VSyncedContent,
         @ViewBuilder hSyncedContent: () -> HSyncedContent,
         @ViewBuilder topLeftCell: () -> TopLeftCell) {
        self.content = content()
        self.verticallySyncedContent = vSyncedContent()
        self.horizontallySyncedContent = hSyncedContent()
        self.topLeftCell = topLeftCell()
    }

    @State private var offset = CGPoint(x: 0, y: 0)

    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Spacer()
            HStack(spacing: 0) {
                topLeftCell
                // Synchronised with main ScrollView
                ScrollView(.horizontal) {
                    horizontallySyncedContent
                        .offset(x: -offset.x)
                }
                .disabled(true)
            }

            HStack(alignment: .top, spacing: 0) {
                // Synchronised with main ScrollView
                ScrollView {
                    verticallySyncedContent
                        .offset(y: -offset.y)
                }
                .disabled(true)

                // MainScrollView
                ScrollView([.vertical, .horizontal]) {
                    content
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                                   value: CGPoint(x:-$0.frame(in: .named("scroll")).origin.x,y:-$0.frame(in: .named("scroll")).origin.y) )
                        })
                        .onPreferenceChange(ViewOffsetKey.self) { value in
                            print("offset >> \(value)")
                            offset = value
                        }
                }
                .coordinateSpace(name: "scroll")
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue = CGPoint.zero

    typealias Value = CGPoint
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}



struct SyncedScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SyncedScrollView {
            LazyHStack(spacing: 0) {
                ForEach(1..<100) { column in
                    LazyVStack(spacing: 0) {
                        ForEach(1..<100) { row in
                            Text("R:\(row)\nC:\(column)")
                                .frame(width: 80, height: 80)
                        }
                        .background(.green)
                    }
                }
            }
        } vSyncedContent: {
            LazyVStack(spacing: 0) {
                ForEach(1..<100) { row in
                    Text("R:\(row)\nC:\(0)")
                        .frame(width: 80, height: 80)
                }
                .background(.pink)
            }
            .frame(width: 80)
        } hSyncedContent: {
            LazyHStack(spacing: 0) {
                ForEach(1..<100) { column in
                    Text("R:\(0)\nC:\(column)")
                        .frame(width: 80, height: 80)
                }
                .background(.yellow)
            }
            .frame(height: 80)
        } topLeftCell: {
            Text("R:\(0)\nC:\(0)")
                .frame(width: 80, height: 80)
                .background(.blue)
        }
    }
}
