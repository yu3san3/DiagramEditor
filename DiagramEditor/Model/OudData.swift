//
//  OudData.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import Foundation

struct OudData {
    var fileType: String
    let rosen: Rosen
    let dispProp: DispProp
    var fileTypeAppComment: String
}

struct Ressya: Hashable { //インデント数: 4
    var houkou: String
    var syubetsu: Int
    var ressyabangou: String //任意
    var ressyamei: String //任意
    var gousuu: String //任意
    var ekiJikoku: [String]
    var bikou: String //任意
}

struct Kudari { //インデント数: 3
    let ressya: [Ressya]
}

struct Nobori { //インデント数: 3
    let ressya: [Ressya]
}

struct Dia { //インデント数: 2
    var diaName: String
    let kudari: Kudari
    let nobori: Nobori
}

struct Ressyasyubetsu { //インデント数: 2
    var syubetsumei: String
    var ryakusyou: String
    var jikokuhyouMojiColor: String
    var jikokuhyouFontIndex: String
    var diagramSenColor: String
    var diagramSenStyle: String
    var diagramSenIsBold: String //任意
    var stopMarkDrawType: String //任意
}

struct Eki: Hashable { //インデント数: 2
    var ekimei: String
    var ekijikokukeisiki: Ekijikokukeisiki
    var ekikibo: String
    var kyoukaisen: String //任意
    var diagramRessyajouhouHyoujiKudari: String //任意
    var diagramRessyajouhouHyoujiNobori: String //任意
}

struct DispProp { //インデント数: 1
    var jikokuhyouFont: [String]
    var jikokuhyouVFont: String
    var diaEkimeiFont: String
    var diaJikokuFont: String
    var diaRessyaFont: String
    var commentFont: String
    var diaMojiColor: String
    var diaHaikeiColor: String
    var diaRessyaColor: String
    var diaJikuColor: String
    var ekimeiLength: String
    var jikokuhyouRessyaWidth: String
}

struct Rosen { //インデント数: 1
    var rosenmei: String
    let eki: [Eki]
    let ressyasyubetsu: [Ressyasyubetsu]
    let dia: [Dia]
    var kitenJikoku: String
    var diagramDgrYZahyouKyoriDefault: String
    var comment: String
}

enum Ekijikokukeisiki {
    case hatsu
    case hatsuchaku
    case kudariChaku
    case noboriChaku
}
