//
//  OudParser.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import Foundation

let oudData = OuDia.parse(OudData.mockOudText)

class OuDia {
    static func parse(_ text: String) -> OudData {
        var dia = parseDia(text: text)
        
        var ressyasyubetsu: [Ressyasyubetsu] = []
        var eki: [Eki] = []
        
        var diaTargetIndex: Int = 0 //配列内の編集すべきインデックスを示す
        
        for lineRow in text.components(separatedBy: .newlines) {
            let line: String = lineRow.trimmingCharacters(in: .whitespaces)
            if line == "" {
                continue
            } else if line.hasSuffix(".") {
                switch line {
                case "Eki.":
                    eki.append(Eki(ekimei: "", ekijikokukeisiki: .hatsu, ekikibo: "", kyoukaisen: "", diagramRessyajouhouHyoujiKudari: "", diagramRessyajouhouHyoujiNobori: ""))
                case "Ressyasyubetsu.":
                    ressyasyubetsu.append(Ressyasyubetsu(syubetsumei: "", ryakusyou: "", jikokuhyouMojiColor: "", jikokuhyouFontIndex: "", diagramSenColor: "", diagramSenStyle: "", diagramSenIsBold: "", stopMarkDrawType: ""))
                case "Dia.":
                    break
                default:
                    break
                }
            } else if line.contains("=") {
                var keyAndValue: [String] = line.components(separatedBy: "=")
                let key: String = keyAndValue.removeFirst()
                let value: String = keyAndValue.joined(separator: "=")
                if var ekiTarget = eki.lastElement {
                    switch key {
                    case "Ekimei":
                        ekiTarget.ekimei = value
                    case "Ekijikokukeisiki":
                        switch value {
                        case "Jikokukeisiki_Hatsu":
                            ekiTarget.ekijikokukeisiki = .hatsu
                        case "Jikokukeisiki_Hatsuchaku":
                            ekiTarget.ekijikokukeisiki = .hatsuchaku
                        case "Jikokukeisiki_KudariChaku":
                            ekiTarget.ekijikokukeisiki = .kudariChaku
                        case "Jikokukeisiki_NoboriChaku":
                            ekiTarget.ekijikokukeisiki = .noboriChaku
                        default:
                            ekiTarget.ekijikokukeisiki = .hatsu
                        }
                    case "Ekikibo":
                        ekiTarget.ekikibo = value
                    case "Kyoukaisen":
                        ekiTarget.kyoukaisen = value
                    case "DiagramRessyajouhouHyoujiKudari":
                        ekiTarget.diagramRessyajouhouHyoujiKudari = value
                    case "DiagramRessyajouhouHyoujiNobori":
                        ekiTarget.diagramRessyajouhouHyoujiNobori = value
                    default:
                        break
                    }
                    eki.lastElement = ekiTarget
                }
                if var ressyasyubetsuTarget = ressyasyubetsu.lastElement {
                    switch key {
                    case "Syubetsumei":
                        ressyasyubetsuTarget.syubetsumei = value
                    case "Ryakusyou":
                        ressyasyubetsuTarget.ryakusyou = value
                    case "JikokuhyouMojiColor":
                        ressyasyubetsuTarget.jikokuhyouMojiColor = value
                    case "JikokuhyouFontIndex":
                        ressyasyubetsuTarget.jikokuhyouFontIndex = value
                    case "DiagramSenColor":
                        ressyasyubetsuTarget.diagramSenColor = value
                    case "DiagramSenStyle":
                        ressyasyubetsuTarget.diagramSenStyle = value
                    case "DiagramSenIsBold":
                        ressyasyubetsuTarget.diagramSenIsBold = value
                    case "StopMarkDrawType":
                        ressyasyubetsuTarget.stopMarkDrawType = value
                    default:
                        break
                    }
                    ressyasyubetsu.lastElement = ressyasyubetsuTarget
                }
                switch key {
                case "DiaName":
                    dia[diaTargetIndex].diaName = value
                    diaTargetIndex += 1 //DiaName=〇〇の回数を数えるInt
                default:
                    break
                }
            }
        }
        
        var dispProp: DispProp = DispProp(jikokuhyouFont: [], jikokuhyouVFont: "", diaEkimeiFont: "", diaJikokuFont: "", diaRessyaFont: "", commentFont: "", diaMojiColor: "", diaHaikeiColor: "", diaRessyaColor: "", diaJikuColor: "", ekimeiLength: "", jikokuhyouRessyaWidth: "")
        var rosen: Rosen = Rosen(rosenmei: "", eki: eki, ressyasyubetsu: ressyasyubetsu, dia: dia, kitenJikoku: "", diagramDgrYZahyouKyoriDefault: "", comment: "")
        
        for lineRow in text.components(separatedBy: .newlines) {
            let line: String = lineRow.trimmingCharacters(in: .whitespaces)
            if line == "" {
                continue
            } else if line.contains("=") {
                var keyAndValue: [String] = line.components(separatedBy: "=")
                let key: String = keyAndValue.removeFirst()
                let value: String = keyAndValue.joined(separator: "=")
                switch key {
                case "Rosenmei":
                    rosen.rosenmei = value
                case "KitenJikoku":
                    rosen.kitenJikoku = value
                case "DiagramDgrYZahyouKyoriDefault":
                    rosen.diagramDgrYZahyouKyoriDefault = value
                case "Comment":
                    rosen.comment = value
                case "JikokuhyouFont":
                    dispProp.jikokuhyouFont.append(value) //この要素は配列で定義されているのでappend()を用いる
                case "JikokuhyouVFont":
                    dispProp.jikokuhyouVFont = value
                case "DiaEkimeiFont":
                    dispProp.diaEkimeiFont = value
                case "DiaJikokuFont":
                    dispProp.diaJikokuFont = value
                case "DiaRessyaFont":
                    dispProp.diaRessyaFont = value
                case "CommentFont":
                    dispProp.commentFont = value
                case "DiaMojiColor":
                    dispProp.diaMojiColor = value
                case "DiaHaikeiColor":
                    dispProp.diaHaikeiColor = value
                case "DiaRessyaColor":
                    dispProp.diaRessyaColor = value
                case "DiaJikuColor":
                    dispProp.diaJikuColor = value
                case "EkimeiLength":
                    dispProp.ekimeiLength = value
                case "JikokuhyouRessyaWidth":
                    dispProp.jikokuhyouRessyaWidth = value
                default:
                    break
                }
            }
        }
        
        var oudData: OudData = OudData(fileType: "", rosen: rosen, dispProp: dispProp, fileTypeAppComment: "")
        
        for lineRow in text.components(separatedBy: .newlines) {
            let line: String = lineRow.trimmingCharacters(in: .whitespaces)
            if line == "" {
                continue
            } else if line.contains("=") {
                var keyAndValue: [String] = line.components(separatedBy: "=")
                let key: String = keyAndValue.removeFirst()
                let value: String = keyAndValue.joined(separator: "=")
                switch key {
                case "FileType":
                    oudData.fileType = value
                case "FileTypeAppComment":
                    oudData.fileTypeAppComment = value //ここは各Appが名付ける要素
                default:
                    break
                }
            }
        }
        
        return oudData
    }
    
    static func stringify(_ data: OudData) -> String {
        var result: String = ""
        result.append("FileType=\(data.fileType)\n") //OudDataの情報を順番に追加していく
        result.append("Rosen.\n")
        result.append("Rosenmei=\(data.rosen.rosenmei)\n")
        for i in 0..<data.rosen.eki.count {
            result.append("Eki.\n")
            result.append("Ekimei=\(data.rosen.eki[i].ekimei)\n")
            switch data.rosen.eki[i].ekijikokukeisiki {
            case .hatsu:
                result.append("Ekijikokukeisiki=Jikokukeisiki_Hatsu\n")
            case .hatsuchaku:
                result.append("Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku\n")
            case .kudariChaku:
                result.append("Ekijikokukeisiki=Jikokukeisiki_KudariChaku\n")
            case .noboriChaku:
                result.append("Ekijikokukeisiki=Jikokukeisiki_NoboriChaku\n")
            }
            result.append("Ekikibo=\(data.rosen.eki[i].ekikibo)\n")
            if !data.rosen.eki[i].kyoukaisen.isEmpty {
                result.append("Kyoukaisen=\(data.rosen.eki[i].kyoukaisen)\n")
            }
            if !data.rosen.eki[i].diagramRessyajouhouHyoujiKudari.isEmpty {
                result.append("DiagramRessyajouhouHyoujiKudari=\(data.rosen.eki[i].diagramRessyajouhouHyoujiKudari)\n")
            }
            if !data.rosen.eki[i].diagramRessyajouhouHyoujiNobori.isEmpty {
                result.append("DiagramRessyajouhouHyoujiNobori=\(data.rosen.eki[i].diagramRessyajouhouHyoujiNobori)\n")
            }
            result.append(".\n") //Eki. End
        }
        for i in 0..<data.rosen.ressyasyubetsu.count {
            result.append("Ressyasyubetsu.\n")
            result.append("Syubetsumei=\(data.rosen.ressyasyubetsu[i].syubetsumei)\n")
            result.append("Ryakusyou=\(data.rosen.ressyasyubetsu[i].ryakusyou)\n")
            result.append("JikokuhyouMojiColor=\(data.rosen.ressyasyubetsu[i].jikokuhyouMojiColor)\n")
            result.append("JikokuhyouFontIndex=\(data.rosen.ressyasyubetsu[i].jikokuhyouFontIndex)\n")
            result.append("DiagramSenColor=\(data.rosen.ressyasyubetsu[i].diagramSenColor)\n")
            result.append("DiagramSenStyle=\(data.rosen.ressyasyubetsu[i].diagramSenStyle)\n")
            if !data.rosen.ressyasyubetsu[i].diagramSenIsBold.isEmpty {
                result.append("DiagramSenIsBold=\(data.rosen.ressyasyubetsu[i].diagramSenIsBold)\n")
            }
            if !data.rosen.ressyasyubetsu[i].stopMarkDrawType.isEmpty {
                result.append("StopMarkDrawType=\(data.rosen.ressyasyubetsu[i].stopMarkDrawType)\n")
            }
            result.append(".\n") //Ressyasyubetsu. End
        }
        for i in 0..<data.rosen.dia.count {
            result.append("Dia.\n")
            result.append("DiaName=\(data.rosen.dia[i].diaName)\n")
            result.append("Kudari.\n")
            for j in 0..<data.rosen.dia[i].kudari.ressya.count {
                result.append("Ressya.\n")
                if !data.rosen.dia[i].kudari.ressya[j].houkou.isEmpty {
                    result.append("Houkou=\(data.rosen.dia[i].kudari.ressya[j].houkou)\n")
                    result.append("Syubetsu=\(data.rosen.dia[i].kudari.ressya[j].syubetsu)\n")
                }
                if !data.rosen.dia[i].kudari.ressya[j].ressyabangou.isEmpty {
                    result.append("Ressyabangou=\(data.rosen.dia[i].kudari.ressya[j].ressyabangou)\n")
                }
                if !data.rosen.dia[i].kudari.ressya[j].ressyamei.isEmpty {
                    result.append("Ressyamei=\(data.rosen.dia[i].kudari.ressya[j].ressyamei)\n")
                }
                if !data.rosen.dia[i].kudari.ressya[j].gousuu.isEmpty {
                    result.append("Gousuu=\(data.rosen.dia[i].kudari.ressya[j].gousuu)\n")
                }
                if !data.rosen.dia[i].kudari.ressya[j].ekiJikoku.isEmpty {
                    result.append("EkiJikoku=\(EkiJikoku.stringify(data.rosen.dia[i].kudari.ressya[j].ekiJikoku))\n")
                }
                if !data.rosen.dia[i].kudari.ressya[j].bikou.isEmpty {
                    result.append("Bikou=\(data.rosen.dia[i].kudari.ressya[j].bikou)\n")
                }
                result.append(".\n") //Ressya. End
            }
            result.append(".\n") //Kudari. End
            result.append("Nobori.\n")
            for j in 0..<data.rosen.dia[i].nobori.ressya.count {
                result.append("Ressya.\n")
                if !data.rosen.dia[i].nobori.ressya[j].houkou.isEmpty {
                    result.append("Houkou=\(data.rosen.dia[i].nobori.ressya[j].houkou)\n")
                    result.append("Syubetsu=\(data.rosen.dia[i].nobori.ressya[j].syubetsu)\n")
                }
                if !data.rosen.dia[i].nobori.ressya[j].ressyabangou.isEmpty {
                    result.append("Ressyabangou=\(data.rosen.dia[i].nobori.ressya[j].ressyabangou)\n")
                }
                if !data.rosen.dia[i].nobori.ressya[j].ressyamei.isEmpty {
                    result.append("Ressyamei=\(data.rosen.dia[i].nobori.ressya[j].ressyamei)\n")
                }
                if !data.rosen.dia[i].nobori.ressya[j].gousuu.isEmpty {
                    result.append("Gousuu=\(data.rosen.dia[i].nobori.ressya[j].gousuu)\n")
                }
                if !data.rosen.dia[i].nobori.ressya[j].ekiJikoku.isEmpty {
                    result.append("EkiJikoku=\(EkiJikoku.stringify(data.rosen.dia[i].nobori.ressya[j].ekiJikoku))\n") //[String] -> Stringに変換して代入
                }
                if !data.rosen.dia[i].nobori.ressya[j].bikou.isEmpty {
                    result.append("Bikou=\(data.rosen.dia[i].nobori.ressya[j].bikou)\n")
                }
                result.append(".\n") //Ressya. End
            }
            result.append(".\n") //Nobori. End
            result.append(".\n") //Dia. End
        }
        result.append("KitenJikoku=\(data.rosen.kitenJikoku)\n")
        result.append("DiagramDgrYZahyouKyoriDefault=\(data.rosen.diagramDgrYZahyouKyoriDefault)\n")
        result.append("Comment=\(data.rosen.comment)\n")
        result.append(".\n") //Rosen End
        result.append("DispProp.\n")
        for i in 0..<data.dispProp.jikokuhyouFont.count {
            result.append("JikokuhyouFont=\(data.dispProp.jikokuhyouFont[i])\n")
        }
        result.append("JikokuhyouVFont=\(data.dispProp.jikokuhyouVFont)\n")
        result.append("DiaEkimeiFont=\(data.dispProp.diaEkimeiFont)\n")
        result.append("DiaJikokuFont=\(data.dispProp.diaJikokuFont)\n")
        result.append("DiaRessyaFont=\(data.dispProp.diaRessyaFont)\n")
        result.append("CommentFont=\(data.dispProp.commentFont)\n")
        result.append("DiaMojiColor=\(data.dispProp.diaMojiColor)\n")
        result.append("DiaHaikeiColor=\(data.dispProp.diaHaikeiColor)\n")
        result.append("DiaRessyaColor=\(data.dispProp.diaRessyaColor)\n")
        result.append("DiaJikuColor=\(data.dispProp.diaJikuColor)\n")
        result.append("EkimeiLength=\(data.dispProp.ekimeiLength)\n")
        result.append("JikokuhyouRessyaWidth=\(data.dispProp.jikokuhyouRessyaWidth)\n")
        result.append(".\n") //DispProp End
        result.append("FileTypeAppComment=" + "Diagram Editor Ver. Alpha 1.0.0") //ここは各Appが名付ける要素
        
        return result
    }
}

private extension OuDia {
    static func parseDia(text: String) -> [Dia] {
        let ressya = parseRessya(text: text)
        let dia = generateDia(kudariRessya: ressya.kudari, noboriRessya: ressya.nobori)
        return dia

        func parseRessya(text: String) -> (kudari: [[Ressya]], nobori: [[Ressya]]) {
            enum ProcessState {
                case none
                case kudari
                case nobori
            }

            var kudariRessya: [[Ressya]] = []
            var noboriRessya: [[Ressya]] = []

            var isRessya = false
            var processState: ProcessState = .none //どの構成要素を処理しているかを示す

            for lineRow in text.components(separatedBy: .newlines) { //textを1行づつ処理
                let line: String = lineRow.trimmingCharacters(in: .whitespaces) //行の端にある空白を削除
                if line.isEmpty {
                    continue
                } else if line == "." { //行がピリオドの場合
                    resetProcessState()
                } else if line.hasSuffix(".") { //行がピリオドで終わっている場合
                    handleScopeEntry(line: line)
                } else if line.contains("=") { // 行にイコールが含まれている場合
                    setValueFromKey(line: line)
                }
            }
            return (kudari: kudariRessya, nobori: noboriRessya)

            func resetProcessState() {
                if isRessya {
                    isRessya = false
                } else {
                    processState = .none
                }
            }

            func handleScopeEntry(line: String) {
                switch line {
                case "Dia.":
                    kudariRessya.append([])
                    noboriRessya.append([])
                case "Kudari.":
                    processState = .kudari //Kudari.の処理中であることを示すBool
                case "Nobori.":
                    processState = .nobori
                case "Ressya.":
                    isRessya = true
                    if case .kudari = processState, var kudariTarget = kudariRessya.lastElement {
                        //空の要素をひとつ追加
                        kudariTarget.append(Ressya(houkou: "", syubetsu: 0, ressyabangou: "", ressyamei: "", gousuu: "", ekiJikoku: [], bikou: ""))
                        kudariRessya.lastElement = kudariTarget
                    }
                    if case .nobori = processState, var noboriTarget = noboriRessya.lastElement {
                        noboriTarget.append(Ressya(houkou: "", syubetsu: 0, ressyabangou: "", ressyamei: "", gousuu: "", ekiJikoku: [], bikou: ""))
                        noboriRessya.lastElement = noboriTarget
                    }
                default:
                    break
                }
                return
            }

            func setValueFromKey(line: String) {
                var keyAndValue: [String] = line.components(separatedBy: "=")
                let key: String = keyAndValue.removeFirst() //イコールの左側
                let value: String = keyAndValue.joined(separator: "=") //イコールの右側
                if case .kudari = processState, var kudariRessyaTarget = kudariRessya.lastElement?.lastElement {
                    updateRessya(in: &kudariRessyaTarget, withKey: key, value: value)
                    kudariRessya.lastElement?.lastElement = kudariRessyaTarget
                } else if case .nobori = processState, var noboriRessyaTarget = noboriRessya.lastElement?.lastElement {
                    updateRessya(in: &noboriRessyaTarget, withKey: key, value: value)
                    noboriRessya.lastElement?.lastElement = noboriRessyaTarget
                }
                return

                func updateRessya(in ressya: inout Ressya, withKey key: String, value: String) {
                    switch key {
                    case "Houkou":
                        ressya.houkou = value
                    case "Syubetsu":
                        if let valueInt = Int(value) {
                            ressya.syubetsu = valueInt
                        }
                    case "Ressyabangou":
                        ressya.ressyabangou = value
                    case "Ressyamei":
                        ressya.ressyamei = value
                    case "Gousuu":
                        ressya.gousuu = value
                    case "EkiJikoku":
                        ressya.ekiJikoku = EkiJikoku.parse(value) //String -> [String]に変換して代入
                    case "Bikou":
                        ressya.bikou = value
                    default:
                        break
                    }
                    return
                }
            }
        }

        func generateDia(kudariRessya: [[Ressya]], noboriRessya: [[Ressya]]) -> [Dia] {
            let kudari: [Kudari] = kudariRessya.map { Kudari(ressya: $0) }
            let nobori: [Nobori] = noboriRessya.map { Nobori(ressya: $0) }
            let dia: [Dia] = zip(kudari, nobori).map { Dia(diaName: "", kudari: $0.0, nobori: $0.1) }
            return dia
        }
    }
}

private class EkiJikoku {
    static func parse(_ text: String) -> [String] {
        var result: [String] = []
        result = text.components(separatedBy: ",")
        return result
    }
    
    static func stringify(_ array: [String]) -> String {
        var result: String = ""
        for i in 0 ..< array.count {
            result += array[i] + ","
        }
        if !result.isEmpty {
            result.removeLast()
        }
        return result
    }
}
