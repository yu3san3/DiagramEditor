//
//  TimeCalculation.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/12/18.
//

import Foundation

class TimeCalculation {
    func getTimeDiff(from firstTime: String, to secondTime: String) -> Int? {
        func getRelevantFormatter(for time: String) -> DateFormatter {
            let formatter = DateFormatter()
            // "123"の場合と"1234"の場合でformatterを使い分ける
            formatter.dateFormat = time.count == 3 ? "Hmm" : "HHmm"
            return formatter
        }

        guard
            let date1 = getRelevantFormatter(for: firstTime).date(from: firstTime),
            let date2 = getRelevantFormatter(for: secondTime).date(from: secondTime)
        else {
            return nil
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)

        return components.minute
    }
}
