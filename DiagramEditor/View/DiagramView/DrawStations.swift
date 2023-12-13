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
            Spacer()
            locateEkis(scale: viewSize.height)
            Divider()
        }
        .frame(width: diagram.ekiWidth)
    }

    @ViewBuilder
    private func locateEkis(scale height: CGFloat) -> some View {
        //Int.maxの際に使用するrunTime
        let maxIntRunTime = 3
        let distances = self.document.distanceBetweenEkis
        //走行時間の合計を計算
        let runTimeSum = CGFloat( distances.reduce(0) {
            //$1がInt.maxだった場合を考慮。そのまま足すとオーバーフローする。
            $0 + ($1 == Int.max ? maxIntRunTime : $1)
        })
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(
                Array(self.document.oudData.rosen.eki.enumerated()),
                id: \.element.id
            ) { index, eki in
                //次駅までの距離。最後の駅ではdistanceが0になる。
                let distance = distances.indices.contains(index) ? distances[index] : 0
                // (Viewの高さ / 走行時間の合計) * 走行距離
                //Int.maxの場合は、走行距離にmaxIntRunTimeを使用
                let intervalHeight = (height / runTimeSum) * CGFloat( distance == Int.max ? maxIntRunTime : distance )
                Text(eki.ekimei)
                    .frame(height: diagram.ekiHeight)
//                    .border(Color.blue)
                Divider()
                Spacer()
                    .frame(height: max(intervalHeight - diagram.ekiHeight, 0) )
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
