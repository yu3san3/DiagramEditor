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
        enum ProcessState {
            case none
            case kudari
            case nobori
        }

        var oudData = OudData(fileType: "",
                              rosen: Rosen(rosenmei: "",
                                           eki: [],
                                           ressyasyubetsu: [],
                                           dia: [],
                                           kitenJikoku: "",
                                           diagramDgrYZahyouKyoriDefault: "",
                                           comment: ""
                                          ),
                              dispProp: DispProp(jikokuhyouFont: [],
                                                 jikokuhyouVFont: "",
                                                 diaEkimeiFont: "",
                                                 diaJikokuFont: "",
                                                 diaRessyaFont: "",
                                                 commentFont: "",
                                                 diaMojiColor: "",
                                                 diaHaikeiColor: "",
                                                 diaRessyaColor: "",
                                                 diaJikuColor: "",
                                                 ekimeiLength: "",
                                                 jikokuhyouRessyaWidth: ""
                                                ),
                              fileTypeAppComment: ""
        )

        var isRessya = false
        var processingHoukouState: ProcessState = .none //どの構成要素を処理しているかを示す

        for lineRow in text.components(separatedBy: .newlines) { //textを1行づつ処理
            let line: String = lineRow.trimmingCharacters(in: .whitespaces) //行の端にある空白を削除
            if line.isEmpty {
                continue
            } else if line == "." { //行がピリオドの場合
                resetProcessingDiaState()
            } else if line.hasSuffix(".") { //行がピリオドで終わっている場合
                handleScopeEntry(line: line)
            } else if line.contains("=") { // 行にイコールが含まれている場合
                setValueFromKey(line: line)
            }
        }
        return oudData

        func resetProcessingDiaState() {
            if isRessya {
                isRessya = false
            } else {
                processingHoukouState = .none
            }
        }

        func handleScopeEntry(line: String) {
            switch line {
            case "Kudari.":
                processingHoukouState = .kudari //Kudari.の処理中であることを示すBool
            case "Nobori.":
                processingHoukouState = .nobori
            case "Ressya.":
                isRessya = true
                if var diaTarget = oudData.rosen.dia.lastElement {
                    if case .kudari = processingHoukouState {
                        //空の要素をひとつ追加
                        diaTarget.kudari.ressya.append( Ressya(houkou: "", syubetsu: 0, ressyabangou: "", ressyamei: "", gousuu: "", ekiJikoku: [], bikou: "") )
                        oudData.rosen.dia.lastElement = diaTarget
                    }
                    if case .nobori = processingHoukouState {
                        diaTarget.nobori.ressya.append( Ressya(houkou: "", syubetsu: 0, ressyabangou: "", ressyamei: "", gousuu: "", ekiJikoku: [], bikou: "") )
                        oudData.rosen.dia.lastElement = diaTarget
                    }
                }
            case "Eki.":
                oudData.rosen.eki.append( Eki(ekimei: "", ekijikokukeisiki: .hatsu, ekikibo: "", kyoukaisen: "", diagramRessyajouhouHyoujiKudari: "", diagramRessyajouhouHyoujiNobori: "") )
            case "Ressyasyubetsu.":
                oudData.rosen.ressyasyubetsu.append( Ressyasyubetsu(syubetsumei: "", ryakusyou: "", jikokuhyouMojiColor: "", jikokuhyouFontIndex: "", diagramSenColor: "", diagramSenStyle: "", diagramSenIsBold: "", stopMarkDrawType: "") )
            case "Dia.":
                oudData.rosen.dia.append( Dia(diaName: "", kudari: Kudari(ressya: []), nobori: Nobori(ressya: [])) )
            default:
                break
            }
            return
        }

        func setValueFromKey(line: String) {
            var keyAndValue: [String] = line.components(separatedBy: "=")
            let key: String = keyAndValue.removeFirst() //イコールの左側
            let value: String = keyAndValue.joined(separator: "=") //イコールの右側
            updateElement()
            return

            func updateElement() {
                if case .kudari = processingHoukouState, var kudariRessyaTarget = oudData.rosen.dia.lastElement?.kudari.ressya.lastElement {
                    updateRessya(in: &kudariRessyaTarget, withKey: key, value: value)
                    oudData.rosen.dia.lastElement?.kudari.ressya.lastElement = kudariRessyaTarget
                } else if case .nobori = processingHoukouState, var noboriRessyaTarget = oudData.rosen.dia.lastElement?.nobori.ressya.lastElement {
                    updateRessya(in: &noboriRessyaTarget, withKey: key, value: value)
                    oudData.rosen.dia.lastElement?.nobori.ressya.lastElement = noboriRessyaTarget
                }
                if var ekiTarget = oudData.rosen.eki.lastElement {
                    updateEki(in: &ekiTarget, withKey: key, value: value)
                    oudData.rosen.eki.lastElement = ekiTarget
                }
                if var ressyasyubetsuTarget = oudData.rosen.ressyasyubetsu.lastElement {
                    updateRessyasyubetsu(in: &ressyasyubetsuTarget, withKey: key, value: value)
                    oudData.rosen.ressyasyubetsu.lastElement = ressyasyubetsuTarget
                }
                if var diaTarget = oudData.rosen.dia.lastElement {
                    updateDia(in: &diaTarget, withKey: key, value: value)
                    oudData.rosen.dia.lastElement = diaTarget
                }
                updateRosen(key: key, value: value)
                updateDispProp(key: key, value: value)
                updateOudData(key: key, value: value)
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
                }

                func updateEki(in eki: inout Eki, withKey key: String, value: String) {
                    switch key {
                    case "Ekimei":
                        eki.ekimei = value
                    case "Ekijikokukeisiki":
                        switch value {
                        case "Jikokukeisiki_Hatsu":
                            eki.ekijikokukeisiki = .hatsu
                        case "Jikokukeisiki_Hatsuchaku":
                            eki.ekijikokukeisiki = .hatsuchaku
                        case "Jikokukeisiki_KudariChaku":
                            eki.ekijikokukeisiki = .kudariChaku
                        case "Jikokukeisiki_NoboriChaku":
                            eki.ekijikokukeisiki = .noboriChaku
                        default:
                            eki.ekijikokukeisiki = .hatsu
                        }
                    case "Ekikibo":
                        eki.ekikibo = value
                    case "Kyoukaisen":
                        eki.kyoukaisen = value
                    case "DiagramRessyajouhouHyoujiKudari":
                        eki.diagramRessyajouhouHyoujiKudari = value
                    case "DiagramRessyajouhouHyoujiNobori":
                        eki.diagramRessyajouhouHyoujiNobori = value
                    default:
                        break
                    }
                }

                func updateRessyasyubetsu(in ressyasyubetsu: inout Ressyasyubetsu, withKey key: String, value: String) {
                    switch key {
                    case "Syubetsumei":
                        ressyasyubetsu.syubetsumei = value
                    case "Ryakusyou":
                        ressyasyubetsu.ryakusyou = value
                    case "JikokuhyouMojiColor":
                        ressyasyubetsu.jikokuhyouMojiColor = value
                    case "JikokuhyouFontIndex":
                        ressyasyubetsu.jikokuhyouFontIndex = value
                    case "DiagramSenColor":
                        ressyasyubetsu.diagramSenColor = value
                    case "DiagramSenStyle":
                        ressyasyubetsu.diagramSenStyle = value
                    case "DiagramSenIsBold":
                        ressyasyubetsu.diagramSenIsBold = value
                    case "StopMarkDrawType":
                        ressyasyubetsu.stopMarkDrawType = value
                    default:
                        break
                    }
                }

                func updateDia(in dia: inout Dia, withKey key: String, value: String) {
                    switch key {
                    case "DiaName":
                        dia.diaName = value
                    default:
                        break
                    }
                }

                func updateRosen(key: String, value: String) {
                    switch key {
                    case "Rosenmei":
                        oudData.rosen.rosenmei = value
                    case "KitenJikoku":
                        oudData.rosen.kitenJikoku = value
                    case "DiagramDgrYZahyouKyoriDefault":
                        oudData.rosen.diagramDgrYZahyouKyoriDefault = value
                    case "Comment":
                        oudData.rosen.comment = value
                    default:
                        break
                    }
                }

                func updateDispProp(key: String, value: String) {
                    switch key {
                    case "JikokuhyouFont":
                        oudData.dispProp.jikokuhyouFont.append(value) //この要素は配列で定義されているのでappend()を用いる
                    case "JikokuhyouVFont":
                        oudData.dispProp.jikokuhyouVFont = value
                    case "DiaEkimeiFont":
                        oudData.dispProp.diaEkimeiFont = value
                    case "DiaJikokuFont":
                        oudData.dispProp.diaJikokuFont = value
                    case "DiaRessyaFont":
                        oudData.dispProp.diaRessyaFont = value
                    case "CommentFont":
                        oudData.dispProp.commentFont = value
                    case "DiaMojiColor":
                        oudData.dispProp.diaMojiColor = value
                    case "DiaHaikeiColor":
                        oudData.dispProp.diaHaikeiColor = value
                    case "DiaRessyaColor":
                        oudData.dispProp.diaRessyaColor = value
                    case "DiaJikuColor":
                        oudData.dispProp.diaJikuColor = value
                    case "EkimeiLength":
                        oudData.dispProp.ekimeiLength = value
                    case "JikokuhyouRessyaWidth":
                        oudData.dispProp.jikokuhyouRessyaWidth = value
                    default:
                        break
                    }
                }

                func updateOudData(key: String, value: String) {
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
        }
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
