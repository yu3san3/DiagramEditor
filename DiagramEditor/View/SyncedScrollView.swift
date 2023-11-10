//
//  SyncedScrollView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/11/10.
//

import SwiftUI

struct SyncedScrollView<Content:View,VSyncedContent:View,HSyncedContent:View>: View {

    let content:Content
    let verticallySyncedContent:VSyncedContent
    let horizontallySyncedContent:HSyncedContent

    init(@ViewBuilder content: () -> Content, @ViewBuilder vSyncedContent: () -> VSyncedContent, @ViewBuilder hSyncedContent: () -> HSyncedContent) {
        self.content = content()
        self.verticallySyncedContent = vSyncedContent()
        self.horizontallySyncedContent = hSyncedContent()
    }

    @State private var offset = CGPoint(x: 0, y: 0)

    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            Spacer()
            // Synchronised with main ScrollView
            ScrollView(.horizontal) {
                HStack {
                    horizontallySyncedContent
                }
                .offset(x: -offset.x)
            }
            .disabled(true)

            HStack(alignment: .top,spacing: 0) {
                // Synchronised with main ScrollView
                ScrollView {
                    VStack {
                        verticallySyncedContent
                    }
                    .offset(y: -offset.y)
                }
                .disabled(true)

                // MainScrollView
                ScrollView([.vertical, .horizontal]) {
                    VStack {
                        content
                    }
                    .background( GeometryReader {
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
        SyncedScrollView{
            LazyHStack{
                ForEach(1..<30) { column in
                    LazyVStack{
                        ForEach(1..<30) { row in
                            Text("R:\(row)\nC:\(column)")
                                .frame(width: 80, height: 80)
                        }.background(.green)
                    }
                }
            }
        }vSyncedContent:{
            ForEach(1..<30) { row in
                Text("R:\(row)\nC:\(0)")
                    .frame(width: 80, height: 80)
            }.background(.pink)
                .padding(.trailing,8)
        }hSyncedContent:{
            ForEach(0..<30) { column in
                Text("R:\(0)\nC:\(column)")
                    .frame(width: 80, height: 80)
            }.background(.yellow)
                .padding(.bottom,8)
        }
    }
}
