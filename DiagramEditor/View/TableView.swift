//
//  TableView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

struct Table {
    //表の属性を決める
    let columnWidth: CGFloat = 40
    let columnHeight: CGFloat = 20
    let rowWidth: CGFloat = 80
    let rowHeight: CGFloat = 20
    
    //Viewの幅と表の大きさを渡すと余白の幅が返ってくる
    func calculateMarginWidth(viewWidth: CGFloat, contentSize: CGSize) -> CGFloat {
        let viewWidthExcludingTopLeftCell: CGFloat = viewWidth - self.rowWidth
        let columnWidthExcludingTopLeftCell: CGFloat = contentSize.width - self.rowWidth
        return viewWidthExcludingTopLeftCell - columnWidthExcludingTopLeftCell
    }
    
    //Viewの高さと表の大きさを渡すと余白の高さが返ってくる
    func calculateMarginHeight(viewHeight: CGFloat, contentSize: CGSize) -> CGFloat {
        let viewHeightExcludingTopLeftCell: CGFloat = viewHeight - self.columnHeight
        let rowHeightExcludingTopLeftCell: CGFloat = contentSize.height - self.columnHeight
        return viewHeightExcludingTopLeftCell - rowHeightExcludingTopLeftCell
    }
}

struct JikokuhyouView: View {
    let houkou: Houkou
    let rows: [Ressya]// = oudData.rosen.dia[0].kudari.ressya
    let columns: [Eki]// = oudData.rosen.eki
    let ressyasyubetsu: [Ressyasyubetsu]
    
    let columnCount: Int
    let rowCount: Int
    
    //時刻形式が発着である回数を数える
    var hatsuchakuCount: Int {
        columns.filter { $0.ekijikokukeisiki == .hatsuchaku }.count
    }
    
    //表の大きさ
    var contentSize: CGSize {
        .init(
            width: (table.columnWidth * CGFloat(columnCount)) + table.rowWidth,
            //高さ: (列の高さ * (駅数 + うち時刻形式が発着となっている回数)) + 行の高さ * 8 * 6 (← 固定行の分の高さ * 備考の高さ)
            height: (table.rowHeight * CGFloat(rowCount+hatsuchakuCount)) + table.columnHeight * (8 + 6)
        )
    }
    
    @State private var scrollOffset: CGPoint = .zero
    
    var table = Table()

    init(houkou: Houkou, ressya: [Ressya], rosen: Rosen) {
        self.houkou = houkou
        switch houkou {
        case .kudari:
            self.columns = rosen.eki
        case .nobori:
            self.columns = rosen.eki.reversed()
        }
        self.rows = ressya
        self.ressyasyubetsu = rosen.ressyasyubetsu
        self.columnCount = ressya.count
        self.rowCount = rosen.eki.count
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                //実際に画面に表示されてるView
                HStack(spacing: 0) {
                    leftContentView()
                        .frame(width: table.rowWidth)
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
            topLeftCell
            //列
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(columns) { column in
                        StationListView(houkou: houkou, column: column, table: table)
                    }
                    VStack {
                        VText("備考")
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

    var topLeftCell: some View {
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
                VText("列車名")
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
    }

    func rightContentView(_ geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            //行
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(rows) { column in
                        VStack(spacing: 0) {
                            Text(column.ressyabangou)
                                .font(.caption)
                                .frame(
                                    width: table.columnWidth,
                                    height: table.columnHeight
                                )
                                .border(Color.red)
                            //column.syubetsuはInt型
                            if ressyasyubetsu.indices.contains(column.syubetsu) {
                                Text(ressyasyubetsu[column.syubetsu].ryakusyou)
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
                            VStack {
                                VText(column.ressyamei)
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
                .frame(height: table.columnHeight*8)
            }
            .disabled(true)
            //コンテンツ
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                JikokuView(ressyas: rows, ekis: columns)
                    .offset(
                        //scrollOffset - 余白調整分
                        x: scrollOffset.x - table.calculateMarginWidth(viewWidth: geometry.size.width, contentSize: contentSize)/2,
                        y: scrollOffset.y - table.calculateMarginHeight(viewHeight: geometry.size.height, contentSize: contentSize)/2
                    )
            }
            .disabled(true)
        }
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
            //scrollOffsetに座標を伝えてViewに反映させる
            scrollOffset = zeroIn(value, geometry: geometry)
        }
    }
    
    //表の要素が少ない時の表示のズレを補正する関数
    func zeroIn(_ value: CGPoint, geometry: GeometryProxy) -> CGPoint {
        var result: CGPoint = .zero
        result.x = value.x - max((table.calculateMarginWidth(viewWidth: geometry.size.width, contentSize: contentSize))/2, 0)
        result.y = value.y - max((table.calculateMarginHeight(viewHeight: geometry.size.height, contentSize: contentSize))/2, 0)
        print(result)
        return result
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

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        JikokuhyouView(houkou: .kudari,
                       ressya: OudData.mockOudData.rosen.dia[0].kudari.ressya,
                       rosen: OudData.mockOudData.rosen
        )
        JikokuhyouView(houkou: .nobori,
                       ressya: OudData.mockOudData.rosen.dia[0].nobori.ressya,
                       rosen: OudData.mockOudData.rosen
        )
    }
}
