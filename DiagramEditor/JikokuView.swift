//
//  JikokuView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

struct JikokuView: View {
    let jikoku: [String]
    let rows: [Eki]
    let index: Int
    
    var body: some View {
        if jikoku.indices.contains(index) {
            let jikokuComponents: [String] = jikoku[index].components(separatedBy: ";") //通過パターンと時刻データを分ける
            if jikokuComponents.indices.contains(1) { //時刻データがある場合。jikokuArray[0]で通過パターンを取り出せる。
                if jikokuComponents[1].last == "/" { //発時刻省略(着時刻のみ) 600/
                    if rows[index].ekijikokukeisiki != .hatsuchaku {
                        Text(jikokuComponents[1].dropLast())
                    } else {
                        Text(jikokuComponents[1].dropLast())
                        Text("・・")
                    }
                } else if jikokuComponents[1].contains("/") { //省略なし 600/610
                    let hatsuchakuComponents: [String] = jikokuComponents[1].components(separatedBy: "/") //発時刻と着時刻に分ける
                    ForEach (hatsuchakuComponents, id: \.self) { component in
                        Text(component)
                    }
                } else { //着時刻省略(発時刻のみ) 600
                    if jikoku.indices.contains(index-1) {
                        if jikoku[index-1] == "3" || jikoku[index-1] == "" {
                            if rows[index].ekijikokukeisiki == .hatsuchaku {
                                Text("!?")
                            }
                        }
                    }
                    Text(jikokuComponents[1])
                }
            } else { //通過パターン(停車・通過など)のみの場合。時刻データがない場合。
                if rows[index].ekijikokukeisiki != .hatsuchaku {
                    passingPatternView(patternNum: jikokuComponents[0])
                } else {
                    if jikoku[index-1] == "3" {
                        Text("||")
                        passingPatternView(patternNum: jikokuComponents[0])
                    } else {
                        //Ekijikokukeisikiが発着の場合は、2回描画する
                        passingPatternView(patternNum: jikokuComponents[0])
                        passingPatternView(patternNum: jikokuComponents[0])
                    }
                }
            }
        } else {
            if rows[index].ekijikokukeisiki != .hatsuchaku {
//                Text(String(index))
                Text("・・")
            } else {
                //Ekijikokukeisikiが発着の場合は、2回描画する
//                Text(String(index))
//                Text(String(index))
                Text("・・")
                Text("・・")
            }
        }
    }

    
    func passingPatternView(patternNum: String) -> some View {
        Group {
            switch patternNum {
            case "": //時刻データが空(運行なし)。
                Text("・・")
            case "1": //停車
                Text("◯")
            case "2": //通過
                Text("レ")
            case "3": //経由なし
                Text("||")
            default:
                Text("？")
            }
        }
    }
}

struct JikokuView_Previews: PreviewProvider {
    static var previews: some View {
        let index: Int = 0
        JikokuView(jikoku: oudData.rosen.dia[0].kudari.ressya[0].ekiJikoku, rows: oudData.rosen.eki, index: index)
    }
}
