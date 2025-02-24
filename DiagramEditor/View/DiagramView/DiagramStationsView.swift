//
//  DiagramStationsView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/12.
//

import SwiftUI

struct DiagramStationsView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("DummyStation")
            Divider()
        }
        .frame(width: Const.Diagram.stationWidth)
    }
}

#Preview {
    DiagramStationsView()
}
