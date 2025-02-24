//
//  DiagramTimesView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/12.
//

import SwiftUI

struct DiagramTimesView: View {
    let scale: Int

    var body: some View {
        VStack(spacing: 0) {
            LazyHStack(spacing: 0) {
                ForEach(0..<24) { time in
                    Text(time.description)
                        .frame(
                            width: .init(scale * 60)
                        )
                }
            }

            Divider()
        }
    }
}

#Preview {
    DiagramTimesView(scale: 100)
}
