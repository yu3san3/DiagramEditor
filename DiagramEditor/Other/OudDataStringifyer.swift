//
//  OudDataStringifyer.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/09/03.
//

import Foundation

class OudDataStringifyer {
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
                        result.append("Houkou=\(ressya.houkou.rawValue)\n")
                        result.append("Syubetsu=\(ressya.syubetsu)\n")
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
                            result.append("EkiJikoku=\( EkiJikokuStringifyer.stringify(ressya.ekiJikoku) )\n")
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

class EkiJikokuStringifyer {
    static func stringify(_ jikokuArr: [Jikoku]) -> String {
        var result: String = ""
        for jikoku in jikokuArr {
            switch jikoku {
            case let notOperate where notOperate.arrivalStatus == .notOperate: //""
                break
            case let onlyArrivalStatus where onlyArrivalStatus.chaku.isEmpty && onlyArrivalStatus.hatsu.isEmpty: //"3"
                result.append(onlyArrivalStatus.arrivalStatus.rawValue)
            case let arrivalStatusAndTime where !arrivalStatusAndTime.chaku.isEmpty || !arrivalStatusAndTime.hatsu.isEmpty: //"1;123/456"
                result.append(arrivalStatusAndTime.arrivalStatus.rawValue)
                result.append(";")
                switch arrivalStatusAndTime {
                case let departure where departure.chaku.isEmpty && !departure.hatsu.isEmpty: //123
                    result.append(departure.hatsu)
                case let arrival where !arrival.chaku.isEmpty && arrival.hatsu.isEmpty: //123/
                    result.append(arrival.chaku)
                    result.append("/")
                case let arrivalAndDeparture where !arrivalAndDeparture.chaku.isEmpty && !arrivalAndDeparture.hatsu.isEmpty: //123/456
                    result.append(arrivalAndDeparture.chaku)
                    result.append("/")
                    result.append(arrivalAndDeparture.hatsu)
                default:
                    break
                }
            default:
                break
            }
            result.append(",")
        }
        result.removeLast()
        return result
    }
}
