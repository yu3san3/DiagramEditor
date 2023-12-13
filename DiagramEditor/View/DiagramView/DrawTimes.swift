//
//  DrawTimes.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/12.
//

import SwiftUI

struct DrawTimes: View {
    @Binding var viewSize: CGSize
    let times = 24

    let diagram = Diagram()

    var body: some View {
        VStack(spacing: 0) {
            locateTimes()
            Divider()
        }
    }

    @ViewBuilder
    func locateTimes() -> some View {
        let intervalWidth = max( ( viewSize.width / CGFloat(times) ) - diagram.timeWidth, 0)
        HStack(spacing: intervalWidth) {
            ForEach(0..<times+1, id: \.self) { index in
                Text("\(index)")
                    .frame(width: diagram.timeWidth)
            }
        }
        .offset(x: -diagram.timeWidth/2 )
    }
}

#Preview {
    @State var viewSize = CGSize(width: 100, height: 20)
    return ScrollView(.horizontal) {
        DrawTimes(viewSize: $viewSize)
    }
}
