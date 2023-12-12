//
//  DrawStations.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/12.
//

import SwiftUI

struct DrawStations: View {
    @EnvironmentObject var document: DiagramEditorDocument

    var ekiCount: Int {
        self.document.oudData.rosen.eki.count
    }

    var body: some View {
        locateEkis(scale: 400)
    }

    @ViewBuilder
    private func locateEkis(scale height: CGFloat) -> some View {
        let textHeight: CGFloat = 20
        //Int.maxの際に使用するrunTime
        let maxIntRunTime = 3
        //走行時間の合計を計算
        let runTimeSum = CGFloat( self.document.distanceBetweenEkis.reduce(0) {
            //$1がInt.maxだった場合を考慮。そのまま足すとオーバーフローする。
            $0 + ($1 == Int.max ? maxIntRunTime : $1)
        })
        LazyVStack(spacing: 0) {
            ForEach(
                Array(self.document.oudData.rosen.eki.enumerated()),
                id: \.element.id
            ) { index, eki in
                let distance = self.document.distanceBetweenEkis.indices.contains(index) ? self.document.distanceBetweenEkis[index] : 0
                // (Viewの高さ / 走行時間の合計) * 走行距離
                //Int.maxの場合は、走行距離にmaxIntRunTimeを使用
                let intervalHeight = (height / runTimeSum) * CGFloat( distance == Int.max ? maxIntRunTime : distance )
                Text(eki.ekimei)
                    .frame(height: textHeight)
                    .border(Color.blue)
                Spacer()
                    .frame(height: max(intervalHeight - textHeight, 0) )
            }
        }
    }
}

#Preview {
    ScrollView(.vertical) {
        DrawStations()
            .environmentObject(DiagramEditorDocument())
    }
}
