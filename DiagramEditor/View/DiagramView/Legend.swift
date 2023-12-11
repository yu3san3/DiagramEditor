//
//  Legend.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/07.
//

import SwiftUI

struct Legend: View {
    @EnvironmentObject var document: DiagramEditorDocument

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<24) { _ in
                drawVLine(interval: 60)
            }
        }
        .onAppear {
            print(getMinimumRunTime())
        }
    }

    @ViewBuilder
    func drawVLine(interval: CGFloat) -> some View {
        let lineWidth: CGFloat = 1
        VLine()
            .stroke(Color.gray.opacity(0.5), lineWidth: lineWidth)
            .frame(width: lineWidth, height: 500)
        Spacer()
            .frame(width: interval - lineWidth )
    }

    private func getMinimumRunTime() -> [Int] {
        let ekiCount = self.document.oudData.rosen.eki.count
        var result = Array(repeating: Int.max, count: ekiCount - 1)
        let ressyas = self.document.oudData.rosen.dia[0].kudari.ressya
        //駅間0分を防ぐための最小値
        let minimumValue = 1
        for ressya in ressyas {
            print("---")
            var previousHatsu: String? = nil
            for (i, jikoku) in ressya.ekiJikoku.enumerated() {
                //時刻データなし
                if jikoku.chaku.isEmpty && jikoku.hatsu.isEmpty {
                    previousHatsu = nil
                    print("! \(i)")
                    continue
                }
                //前の駅に停車している、かつ着時刻か発時刻のデータあり
                if let prevHatsu = previousHatsu,
                    !jikoku.chaku.isEmpty || !jikoku.hatsu.isEmpty {
                    print(i)
                    //着時刻のデータがあればそれを使い、そうでなければ発時刻を使う
                    let relevantTime = !jikoku.chaku.isEmpty ? jikoku.chaku : jikoku.hatsu
                    let diff: Int! = getTimeDiff(from: prevHatsu, to: relevantTime)
                    result[i-1] = max(minimumValue, min(diff, result[i-1]) )
                }
                //発車時刻を保持
                previousHatsu = jikoku.hatsu
            }
        }
        return result
    }

    private func getTimeDiff(from firstTime: String, to secondTime: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"

        guard let date1 = dateFormatter.date(from: firstTime),
              let date2 = dateFormatter.date(from: secondTime) else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)

        return components.minute
    }
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

#Preview {
    ScrollView([.horizontal, .vertical]) {
        Legend()
            .environmentObject(DiagramEditorDocument())
    }.frame(width: 320, height: 200)
}
