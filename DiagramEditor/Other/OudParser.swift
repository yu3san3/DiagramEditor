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
                oudData.rosen.eki.append( Eki(ekimei: "", ekijikokukeisiki: .hatsu, ekikibo: .ippan, kyoukaisen: "", diagramRessyajouhouHyoujiKudari: "", diagramRessyajouhouHyoujiNobori: "") )
            case "Ressyasyubetsu.":
                oudData.rosen.ressyasyubetsu.append( Ressyasyubetsu(syubetsumei: "", ryakusyou: "", jikokuhyouMojiColor: "", jikokuhyouFontIndex: "", diagramSenColor: "", diagramSenStyle: .jissen, diagramSenIsBold: "", stopMarkDrawType: "") )
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
                        case let jikokukeisiki:
                            eki.ekijikokukeisiki = Ekijikokukeisiki(rawValue: jikokukeisiki) ?? .hatsu
                        }
                    case "Ekikibo":
                        switch value {
                        case let kibo:
                            eki.ekikibo = Ekikibo(rawValue: kibo) ?? .ippan
                        }
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
                        switch value {
                        case let senStyle:
                            ressyasyubetsu.diagramSenStyle = DiagramSenStyle(rawValue: senStyle) ?? .jissen
                        }
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
        stringifyRosen(rosen: data.rosen)
        stringifyDispProp(dispProp: data.dispProp)
        result.append("FileTypeAppComment=" + "Diagram Editor Ver. Alpha 1.0.0") //ここは各Appが名付ける要素
        return result

        func stringifyRosen(rosen: Rosen) {
            result.append("Rosen.\n")
            result.append("Rosenmei=\(rosen.rosenmei)\n")
            stringifyEki(ekiArr: rosen.eki)
            stringifyRessyasyubetsu(ressyasyubetsuArr: rosen.ressyasyubetsu)
            stringifyDia(diaArr: rosen.dia)
            result.append("KitenJikoku=\(rosen.kitenJikoku)\n")
            result.append("DiagramDgrYZahyouKyoriDefault=\(rosen.diagramDgrYZahyouKyoriDefault)\n")
            result.append("Comment=\(rosen.comment)\n")
            result.append(".\n") //Rosen End
            return

            func stringifyEki(ekiArr: [Eki]) {
                for eki in ekiArr {
                    result.append("Eki.\n")
                    result.append("Ekimei=\(eki.ekimei)\n")
                    result.append("Ekijikokukeisiki=\(eki.ekijikokukeisiki.rawValue)\n")
                    result.append("Ekikibo=\(eki.ekikibo.rawValue)\n")
                    if !eki.kyoukaisen.isEmpty {
                        result.append("Kyoukaisen=\(eki.kyoukaisen)\n")
                    }
                    if !eki.diagramRessyajouhouHyoujiKudari.isEmpty {
                        result.append("DiagramRessyajouhouHyoujiKudari=\(eki.diagramRessyajouhouHyoujiKudari)\n")
                    }
                    if !eki.diagramRessyajouhouHyoujiNobori.isEmpty {
                        result.append("DiagramRessyajouhouHyoujiNobori=\(eki.diagramRessyajouhouHyoujiNobori)\n")
                    }
                    result.append(".\n") //Eki. End
                }
                return
            }

            func stringifyRessyasyubetsu(ressyasyubetsuArr: [Ressyasyubetsu]) {
                for ressyasyubetsu in ressyasyubetsuArr {
                    result.append("Ressyasyubetsu.\n")
                    result.append("Syubetsumei=\(ressyasyubetsu.syubetsumei)\n")
                    result.append("Ryakusyou=\(ressyasyubetsu.ryakusyou)\n")
                    result.append("JikokuhyouMojiColor=\(ressyasyubetsu.jikokuhyouMojiColor)\n")
                    result.append("JikokuhyouFontIndex=\(ressyasyubetsu.jikokuhyouFontIndex)\n")
                    result.append("DiagramSenColor=\(ressyasyubetsu.diagramSenColor)\n")
                    result.append("DiagramSenStyle=\(ressyasyubetsu.diagramSenStyle.rawValue)\n")
                    if !ressyasyubetsu.diagramSenIsBold.isEmpty {
                        result.append("DiagramSenIsBold=\(ressyasyubetsu.diagramSenIsBold)\n")
                    }
                    if !ressyasyubetsu.stopMarkDrawType.isEmpty {
                        result.append("StopMarkDrawType=\(ressyasyubetsu.stopMarkDrawType)\n")
                    }
                    result.append(".\n") //Ressyasyubetsu. End
                }
                return
            }

            func stringifyDia(diaArr: [Dia]) {
                for dia in diaArr {
                    result.append("Dia.\n")
                    result.append("DiaName=\(dia.diaName)\n")
                    result.append("Kudari.\n")
                    stringifyRessya(ressyaArr: dia.kudari.ressya)
                    result.append(".\n") //Kudari. End
                    result.append("Nobori.\n")
                    stringifyRessya(ressyaArr: dia.nobori.ressya)
                    result.append(".\n") //Nobori. End
                    result.append(".\n") //Dia. End
                }
                return

                func stringifyRessya(ressyaArr: [Ressya]) {
                    for ressya in ressyaArr {
                        result.append("Ressya.\n")
                        if !ressya.houkou.isEmpty {
                            result.append("Houkou=\(ressya.houkou)\n")
                            result.append("Syubetsu=\(ressya.syubetsu)\n")
                        }
                        if !ressya.ressyabangou.isEmpty {
                            result.append("Ressyabangou=\(ressya.ressyabangou)\n")
                        }
                        if !ressya.ressyamei.isEmpty {
                            result.append("Ressyamei=\(ressya.ressyamei)\n")
                        }
                        if !ressya.gousuu.isEmpty {
                            result.append("Gousuu=\(ressya.gousuu)\n")
                        }
                        if !ressya.ekiJikoku.isEmpty {
                            result.append("EkiJikoku=\( EkiJikoku.stringify(ressya.ekiJikoku) )\n")
                        }
                        if !ressya.bikou.isEmpty {
                            result.append("Bikou=\(ressya.bikou)\n")
                        }
                        result.append(".\n") //Ressya. End
                    }
                    return
                }
            }
        }

        func stringifyDispProp(dispProp: DispProp) {
            result.append("DispProp.\n")
            for jikokuhyouFont in dispProp.jikokuhyouFont {
                result.append("JikokuhyouFont=\(jikokuhyouFont)\n")
            }
            result.append("JikokuhyouVFont=\(dispProp.jikokuhyouVFont)\n")
            result.append("DiaEkimeiFont=\(dispProp.diaEkimeiFont)\n")
            result.append("DiaJikokuFont=\(dispProp.diaJikokuFont)\n")
            result.append("DiaRessyaFont=\(dispProp.diaRessyaFont)\n")
            result.append("CommentFont=\(dispProp.commentFont)\n")
            result.append("DiaMojiColor=\(dispProp.diaMojiColor)\n")
            result.append("DiaHaikeiColor=\(dispProp.diaHaikeiColor)\n")
            result.append("DiaRessyaColor=\(dispProp.diaRessyaColor)\n")
            result.append("DiaJikuColor=\(dispProp.diaJikuColor)\n")
            result.append("EkimeiLength=\(dispProp.ekimeiLength)\n")
            result.append("JikokuhyouRessyaWidth=\(dispProp.jikokuhyouRessyaWidth)\n")
            result.append(".\n") //DispProp End
            return
        }
    }
}

private class EkiJikoku {
    static func parse(_ text: String) -> [String] {
        return text.components(separatedBy: ",")
    }
    
    static func stringify(_ jikokuArr: [String]) -> String {
        var result: String = ""
        for jikoku in jikokuArr {
            result += jikoku + ","
        }
        if !result.isEmpty {
            result.removeLast()
        }
        return result
    }
}
