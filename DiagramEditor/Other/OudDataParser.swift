//
//  OudParser.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import Foundation

class OudDataParser {
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
                                           diagramDgrYZahyouKyoriDefault: 60,
                                           comment: ""),
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
                                                 jikokuhyouRessyaWidth: ""),
                              fileTypeAppComment: "")

        var isRessya = false
        //どの構成要素を処理しているかを示す
        var processingHoukouState: ProcessState = .none

        let lineRowArray = text.components(separatedBy: .newlines)
        let ekiCount = lineRowArray.filter{ $0 == "Eki." }.count
        for lineRow in lineRowArray { //textを1行づつ処理
            //行の端にある空白を削除
            let line: String = lineRow.trimmingCharacters(in: .whitespaces)
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
                        diaTarget.kudari.ressya.append( Ressya(houkou: .kudari,
                                                               syubetsu: 0,
                                                               ressyabangou: "",
                                                               ressyamei: "",
                                                               gousuu: "",
                                                               ekiJikoku: EkiJikokuParser.parse("", ekiCount: ekiCount),
                                                               bikou: "")
                        )
                        oudData.rosen.dia.lastElement = diaTarget
                    } else if case .nobori = processingHoukouState {
                        diaTarget.nobori.ressya.append( Ressya(houkou: .kudari,
                                                               syubetsu: 0,
                                                               ressyabangou: "",
                                                               ressyamei: "",
                                                               gousuu: "",
                                                               ekiJikoku: EkiJikokuParser.parse("", ekiCount: ekiCount),
                                                               bikou: "")
                        )
                        oudData.rosen.dia.lastElement = diaTarget
                    }
                }
            case "Eki.":
                oudData.rosen.eki.append( Eki(ekimei: "",
                                              ekijikokukeisiki: .hatsu,
                                              ekikibo: .ippan,
                                              kyoukaisen: "",
                                              diagramRessyajouhouHyoujiKudari: "",
                                              diagramRessyajouhouHyoujiNobori: "")
                )
            case "Ressyasyubetsu.":
                oudData.rosen.ressyasyubetsu.append( Ressyasyubetsu(syubetsumei: "",
                                                                    ryakusyou: "", jikokuhyouMojiColor: "",
                                                                    jikokuhyouFontIndex: 0,
                                                                    diagramSenColor: "",
                                                                    diagramSenStyle: .jissen,
                                                                    diagramSenIsBold: "",
                                                                    stopMarkDrawType: "")
                )
            case "Dia.":
                oudData.rosen.dia.append( Dia(diaName: "",
                                              kudari: Kudari(ressya: []),
                                              nobori: Nobori(ressya: []))
                )
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
                if case .kudari = processingHoukouState,
                   var kudariRessyaTarget = oudData.rosen.dia.lastElement?.kudari.ressya.lastElement {
                    updateRessya(in: &kudariRessyaTarget, withKey: key, value: value)
                    oudData.rosen.dia.lastElement?.kudari.ressya.lastElement = kudariRessyaTarget
                } else if case .nobori = processingHoukouState,
                          var noboriRessyaTarget = oudData.rosen.dia.lastElement?.nobori.ressya.lastElement {
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
                        switch value {
                        case "Kudari":
                            ressya.houkou = .kudari
                        case "Nobori":
                            ressya.houkou = .nobori
                        default:
                            break
                        }
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
                        ressya.ekiJikoku = EkiJikokuParser.parse(value, ekiCount: ekiCount)
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
                        if let valueInt = Int(value) {
                            ressyasyubetsu.jikokuhyouFontIndex = valueInt
                        }
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
                        if let valueInt = Int(value) {
                            oudData.rosen.diagramDgrYZahyouKyoriDefault = valueInt
                        }
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
}

private class EkiJikokuParser {
    static func parse(_ text: String, ekiCount: Int) -> [Jikoku] {
        var result: [Jikoku] = []
        let jikokuArray = text.components(separatedBy: ",")
        for jikoku in jikokuArray {
            switch jikoku {
            case "": //""
                result.append( Jikoku(arrivalStatus: .notOperate, chaku: "", hatsu: "") )
            case let onlyArrivalStatus where !onlyArrivalStatus.contains(";"): //"3"
                let arrivalStatus = ArrivalStatus(rawValue: onlyArrivalStatus) ?? .notOperate
                result.append( Jikoku(arrivalStatus: arrivalStatus, chaku: "", hatsu: "") )
            case let arrivalStatusAndTime where arrivalStatusAndTime.contains(";"): //"1;123/456 etc..."
                let jikokuComponents = arrivalStatusAndTime.components(separatedBy: ";") //["1", "123/456"]
                let arrivalStatus = ArrivalStatus(rawValue: jikokuComponents[0]) ?? .notOperate
                let time = jikokuComponents[1] //"123/456"
                switch time {
                case let departure where !departure.contains("/"): //着時刻省略(123)
                    result.append( Jikoku(arrivalStatus: arrivalStatus, chaku: "", hatsu: departure) )
                case let arrival where arrival.last == "/": //発時刻省略(123/)
                    let arrivalTime = String( arrival.dropLast() )
                    result.append( Jikoku(arrivalStatus: arrivalStatus, chaku: arrivalTime, hatsu: ""))
                case let arrivalAndDeparture where arrivalAndDeparture.contains("/"): //省略なし(123/456)
                    let timeComponents = arrivalAndDeparture.components(separatedBy: "/")
                    let arrival = timeComponents[0]
                    let departure = timeComponents[1]
                    result.append( Jikoku(arrivalStatus: arrivalStatus, chaku: arrival, hatsu: departure) )
                default:
                    print("Ekijikoku Parse Error: unexpected time data")
                    break
                }
            default:
                print("Ekijikoku Parse Error: unexpected jikoku data")
                break
            }
        }
        result += getAdditonalJikoku(diffBetweenEkiAndResultCount: ekiCount - result.count)
        return result
    }

    private static func getAdditonalJikoku(diffBetweenEkiAndResultCount: Int) -> [Jikoku] {
        guard diffBetweenEkiAndResultCount.isPositive else {
            fatalError("ekiCount - result.countの差が0未満です。")
        }
        var additionalJikoku: [Jikoku] = []
        for _ in 0..<diffBetweenEkiAndResultCount { //一意のUUIDを振るためにforで回している
            additionalJikoku.append( Jikoku(arrivalStatus: .notOperate, chaku: "", hatsu: "") )
        }
        return additionalJikoku
    }
}

private extension Int {
    var isPositive: Bool {
        if self >= 0 {
            return true
        } else {
            return false
        }
    }
}
