//
//  DrawStations.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/12.
//

import SwiftUI

struct DrawStations: View {
    @EnvironmentObject var document: DiagramEditorDocument

    @Binding var viewSize: CGSize

    let diagram = Diagram()

    var body: some View {
        HStack(spacing: 0) {
            locateEkis(scale: viewSize.height)
            Divider()
        }
        .frame(width: diagram.ekiWidth)
    }

    @ViewBuilder
    private func locateEkis(scale height: CGFloat) -> some View {
        let underlineWidth: CGFloat = 1
        let distances = self.document.distanceBetweenEkis
        VStack(alignment: .trailing, spacing: 0) {
            //DrawTimesの下部のDividerの分だけ、DrawStationsの始点を下げる
            Spacer()
                .frame(height: 1)
            ForEach(
                Array(self.document.oudData.rosen.eki.enumerated()),
                id: \.element.id
            ) { index, eki in
                //次駅までの距離。最後の駅ではdistanceが0になる。
                let distance = distances.indices.contains(index) ? distances[index] : 0
                // (Viewの高さ / 走行時間の合計) * 走行距離
                //Int.maxの場合は、走行距離にmaxIntRunTimeを使用
                let intervalHeight = (height / self.document.runTimeSum) * CGFloat( distance == Int.max ? self.diagram.maxIntRunTime : distance )
                //駅名のテキスト
                HStack {
                    //???: このSpacerがないとTextの幅が小さくなってしまう
                    Spacer()
                    Text(eki.ekimei)
                        .frame(height: diagram.ekiHeight)
                }
                //区切り線
                Line(direction: .horizontal,
                     lineWidth: underlineWidth,
                     length: .constant(diagram.ekiWidth))
                //次駅との間の幅
                Spacer()
                    .frame(height: max( intervalHeight - (diagram.ekiHeight + underlineWidth), 0) )
            }
        }
    }
}

#Preview {
    let viewSize = Binding.constant( CGSize(width: 500, height: 500) )
    return ScrollView(.vertical) {
        DrawStations(viewSize: viewSize)
            .environmentObject(DiagramEditorDocument())
    }
}
