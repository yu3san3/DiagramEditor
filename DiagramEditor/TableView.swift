//
//  TableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

class Table {
    
    //表の属性を決める
    let columnWidth: CGFloat = 40
    let columnHeight: CGFloat = 20
    let rowWidth: CGFloat = 80
    let rowHeight: CGFloat = 20
    
    //Viewの幅と表の大きさを渡すと余白の幅が返ってくる
    let marginWidth = { (viewWidth: CGFloat, contentSize: CGSize) -> CGFloat in
        let table = Table()
//        print("viewWidth:\(viewWidth)")
        let viewWidthExcludingTopLeftCell: CGFloat = viewWidth - table.rowWidth
        let columnWidthExcludingTopLeftCell: CGFloat = contentSize.width - table.rowWidth
        return viewWidthExcludingTopLeftCell - columnWidthExcludingTopLeftCell
    }
    
    //Viewの高さと表の大きさを渡すと余白の高さが返ってくる
    let marginHeight = { (viewHeight: CGFloat, contentSize: CGSize) -> CGFloat in
        let table = Table()
//        print("viewHeight:\(viewHeight)")
        let viewHeightExcludingTopLeftCell: CGFloat = viewHeight - table.columnHeight
        let rowHeightExcludingTopLeftCell: CGFloat = contentSize.height - table.columnHeight
        return viewHeightExcludingTopLeftCell - rowHeightExcludingTopLeftCell
    }

}

struct JikokuhyouView: View {
    
    let houkou: Houkou
    
    let columns: [Ressya]// = oudData.rosen.dia[0].kudari.ressya
    let rows: [Eki]// = oudData.rosen.eki
    
    let columnCount = { (columns: [Ressya]) -> Int in
        return columns.count
    }
    let rowCount = { (rows: [Eki]) -> Int in
        return rows.count
    }
    
    //時刻形式が発着である回数を数える
    let hatsuchakuCount = { (eki: [Eki]) -> Int in
        var result: Int = 0
        for i in 0..<eki.count {
            if eki[i].ekijikokukeisiki == .hatsuchaku {
                result += 1
            }
        }
        return result
    }
    
    //表の大きさ
    var contentSize: CGSize {
        .init(
            width: (table.columnWidth * CGFloat(columnCount(columns))) + table.rowWidth,
            //高さ: (列の高さ * (駅数 + うち時刻形式が発着となっている回数)) + 行の高さ * 8 * 6 (← 固定行の分の高さ * 備考の高さ)
            height: (table.rowHeight * CGFloat(rowCount(rows)+hatsuchakuCount(rows))) + table.columnHeight * (8 + 6)
        )
    }
    
    @State private var scrollOffset: CGPoint = .zero
    
    var table = Table()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                //実際に画面に表示されてるView
                HStack(spacing: 0) {
                    leftContentView()
                    rightContentView(geometry)
                }
                //スクロールを検知するView
                ObservableScrollView(
                    axis: [.vertical, .horizontal],
                    scrollOffset: $scrollOffset,
                    table: table,
                    geometry: geometry,
                    contentSize: contentSize
                ) { proxy in
                    Color.clear
                        .frame(
                            width: contentSize.width,
                            height: contentSize.height
                        )
                }
            }
        }
    }

    func leftContentView() -> some View {
        VStack(spacing: 0) {
            //左上セル
            VStack(spacing: 0) {
                Text("列車番号")
                    .font(.caption)
                    .frame(
                        width: table.rowWidth,
                        height: table.columnHeight
                    )
                    .border(Color.yellow)
                Text("列車種別")
                    .font(.caption)
                    .frame(
                        width: table.rowWidth,
                        height: table.columnHeight
                    )
                    .border(Color.yellow)
                VStack {
                    VText(text: "列車名")
                        .font(.caption)
                        .padding(3)
                    Spacer()
                }
                .frame(
                    width: table.rowWidth,
                    height: table.columnHeight*6
                )
                .border(Color.yellow)
            }
            //列
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    if houkou == .kudari {
                        ForEach(rows, id: \.self) { row in
                            JikokuhyouRows(houkou: houkou, row: row, table: table)
                        }
                    } else if houkou == .nobori {
                        ForEach(rows.reversed(), id: \.self) { row in
                            JikokuhyouRows(houkou: houkou, row: row, table: table)
                        }
                    }
                    VStack {
                        VText(text: "備考")
                            .font(.caption)
                            .padding(3)
                        Spacer()
                    }
                    .frame(
                        width: table.rowWidth,
                        height: table.columnHeight*6
                    )
                    .border(Color.yellow)
                }
                .offset(y: scrollOffset.y)
            }
            .disabled(true)
        }
    }

    func rightContentView(_ geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            //行
            ScrollView(.horizontal, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(columns, id: \.self) { column in
                            Text(column.ressyabangou)
                                .font(.caption)
                                .frame(
                                    width: table.columnWidth,
                                    height: table.columnHeight
                                )
                                .border(Color.red)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(columns, id: \.self) { column in
                            //column.syubetsuはString型
                            if oudData.rosen.ressyasyubetsu.indices.contains(column.syubetsu) {
                                Text(oudData.rosen.ressyasyubetsu[column.syubetsu].ryakusyou)
                                    .font(.caption)
                                    .frame(
                                        width: table.columnWidth,
                                        height: table.columnHeight
                                    )
                                    .border(Color.red)
                            } else {
                                Text("Index Overflow")
                                    .font(.caption)
                            }
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(columns, id: \.self) { column in
                            VStack {
                                VText(text: column.ressyamei)
                                    .font(.caption)
                                    .padding(3) //ここに数字入れないとなんか表示がおかしくなる
                                Spacer()
                            }
                            .frame(
                                width: table.columnWidth,
                                height: table.columnHeight*6
                            )
                            .border(Color.red)
                        }
                    }
                }
                .offset(x: scrollOffset.x)
            }
            .disabled(true)
            //コンテンツ
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(columns, id: \.self) { column in
                        VStack(spacing: 0) {
                            ForEach(0..<rows.count, id: \.self) { index in
                                JikokuView(
                                    jikoku: column.ekiJikoku,
                                    rows: rows,
                                    index: index
                                )
                                .font(.caption)
                                .frame(
                                    width: table.columnWidth,
                                    height: table.rowHeight
                                )
                                .border(Color.green)
                            }
                            .drawingGroup()
                            VStack { //備考
                                VText(text: column.bikou)
                                    .font(.caption)
                                    .padding(3)
                                Spacer()
                            }
                            .frame(
                                width: table.columnWidth,
                                height: table.columnHeight*6
                            )
                            .border(Color.yellow)
                        }
                    }
                }
                .offset(
                    //scrollOffset - 余白調整分
                    x: scrollOffset.x - table.marginWidth(geometry.size.width, contentSize)/2,
                    y: scrollOffset.y - table.marginHeight(geometry.size.height, contentSize)/2
                )
            }
        }
    }
}

//CGPointに+=演算子を定義
private extension CGPoint {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}

//PreferenceKeyを作成
private struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGPoint.zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value += nextValue()
    }
}

//スクロールを検知するView
private struct ObservableScrollView<Content: View>: View {
    let axis: Axis.Set
    @Binding var scrollOffset: CGPoint
    
    var table: Table
    let geometry: GeometryProxy
    let contentSize: CGSize
    
    let content: (ScrollViewProxy) -> Content
    @Namespace var scrollSpace
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(axis) {
                content(proxy)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                //ターゲットに設定、座標を伝える
                                .preference(
                                    key: ScrollViewOffsetPreferenceKey.self,
                                    value: geo.frame(in: .named(scrollSpace)).origin
                                )
                        }
                    )
            }
        }
        .coordinateSpace(name: scrollSpace)
        //座標の変化を検知する
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
//            DispatchQueue.main.async {
                //scrollOffsetに座標を伝えてViewに反映させる
                scrollOffset = zeroIn(value, geometry: geometry)
                //            print(scrollOffset)
//            }
        }
    }
    
    //表の要素が少ない時の表示のズレを補正する関数
    func zeroIn(_ value: CGPoint, geometry: GeometryProxy) -> CGPoint {
        var result: CGPoint = .zero
        result.x = value.x - max((table.marginWidth(geometry.size.width, contentSize))/2, 0)
        result.y = value.y - max((table.marginHeight(geometry.size.height, contentSize))/2, 0)
        print(result)
        return result
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        JikokuhyouView(houkou: .kudari, columns: oudData.rosen.dia[0].kudari.ressya, rows: oudData.rosen.eki)
        JikokuhyouView(houkou: .nobori, columns: oudData.rosen.dia[0].nobori.ressya, rows: oudData.rosen.eki)
    }
}
