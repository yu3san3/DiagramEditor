//
//  OudData.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import Foundation

struct OudData: Equatable {
    var fileType: String
    var rosen: Rosen
    var dispProp: DispProp
    var fileTypeAppComment: String
}

struct Rosen: Equatable { //インデント数: 1
    var rosenmei: String
    var eki: [Eki]
    var ressyasyubetsu: [Ressyasyubetsu]
    var dia: [Dia]
    var kitenJikoku: String
    var diagramDgrYZahyouKyoriDefault: Int
    var comment: String
}

struct DispProp: Equatable { //インデント数: 1
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

struct Eki: Identifiable, Equatable { //インデント数: 2
    let id = UUID()
    var ekimei: String
    var ekijikokukeisiki: Ekijikokukeisiki
    var ekikibo: Ekikibo
    var kyoukaisen: String //任意
    var diagramRessyajouhouHyoujiKudari: String //任意
    var diagramRessyajouhouHyoujiNobori: String //任意
}

struct Ressyasyubetsu: Equatable { //インデント数: 2
    var syubetsumei: String
    var ryakusyou: String
    var jikokuhyouMojiColor: String
    var jikokuhyouFontIndex: Int
    var diagramSenColor: String
    var diagramSenStyle: DiagramSenStyle
    var diagramSenIsBold: String //任意
    var stopMarkDrawType: String //任意
}

struct Dia: Identifiable, Equatable { //インデント数: 2
    let id = UUID()
    var diaName: String
    var kudari: Kudari
    var nobori: Nobori
}

struct Kudari: Equatable { //インデント数: 3
    var ressya: [Ressya]
}

struct Nobori: Equatable { //インデント数: 3
    var ressya: [Ressya]
}

struct Ressya: Identifiable, Equatable { //インデント数: 4
    let id = UUID()
    var houkou: Houkou
    var syubetsu: Int
    var ressyabangou: String //任意
    var ressyamei: String //任意
    var gousuu: String //任意
    var ekiJikoku: [Jikoku]
    var bikou: String //任意
}

struct Jikoku: Identifiable, Equatable { //インデント数: 5
    let id = UUID()
    var arrivalStatus: ArrivalStatus
    var chaku: String
    var hatsu: String
}

extension OudData {
    static let mockOudData = OudDataParser.parse(OudData.mockOudText)

    //    static let mockOudText = """
    //    FileType=OuDia.1.02
    //    Rosen.
    //    Rosenmei=
    //    Eki.
    //    Ekimei=富波
    //    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=大間館山
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=大間
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=北大間
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=磯谷
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=北磯谷
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=小坂
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=渚
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=久々野
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=杉尾
    //    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=普通
    //    Ryakusyou=普通
    //    JikokuhyouMojiColor=00000000
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=00000000
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=特急ワイドビュー杉尾
    //    Ryakusyou=特急
    //    JikokuhyouMojiColor=000000FF
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=000000FF
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Dia.
    //    DiaName=大間本線
    //    Kudari.
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=1
    //    Ressyabangou=1
    //    Ressyamei=ワイドビュー杉尾
    //    Gousuu=1
    //    EkiJikoku=1;000,2,1;053/055,1;115/117,2,2,2,1;158/200,2,1;223/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=101
    //    EkiJikoku=1;020,1;107/109,1;129/131,1;154/156,1;217/219,1;234/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=1
    //    Ressyabangou=3
    //    Ressyamei=ワイドビュー杉尾
    //    Gousuu=3
    //    EkiJikoku=1;100,2,1;153/155,1;215/217,2,2,2,1;258/300,2,1;323/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=1101
    //    EkiJikoku=,,,,,1;147,1;158/210,1;222/224,1;236/256,1;315/
    //    .
    //    .
    //    Nobori.
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=1
    //    Ressyabangou=2
    //    Ressyamei=ワイドビュー杉尾
    //    Gousuu=2
    //    EkiJikoku=1;132,2,1;158/200,2,2,2,1;241/243,1;303/305,2,1;357/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=1
    //    Ressyabangou=4
    //    Ressyamei=ワイドビュー杉尾
    //    Gousuu=4
    //    EkiJikoku=1;232,2,1;258/300,2,2,2,1;341/343,1;403/405,2,1;457/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=102
    //    EkiJikoku=,,,,1;240,1;256/258,1;318/320,1;343/345,1;405/407,1;454/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=1102
    //    EkiJikoku=1;137,1;155/210,1;223/229,1;241/300,1;311/
    //    .
    //    .
    //    .
    //    KitenJikoku=000
    //    DiagramDgrYZahyouKyoriDefault=60
    //    Comment=
    //    .
    //    DispProp.
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Itaric=1
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1;Itaric=1
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouVFont=PointTextHeight=9;Facename=@ＭＳ ゴシック
    //    DiaEkimeiFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    DiaJikokuFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    DiaRessyaFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    CommentFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    DiaMojiColor=00000000
    //    DiaHaikeiColor=00FFFFFF
    //    DiaRessyaColor=00000000
    //    DiaJikuColor=00C0C0C0
    //    EkimeiLength=6
    //    JikokuhyouRessyaWidth=5
    //    .
    //    FileTypeAppComment=OuDia Ver. 1.02.05
    //    """

    //    static let mockOudText = """
    //    FileType=OuDia.1.02
    //    Rosen.
    //    Rosenmei=
    //    Eki.
    //    Ekimei=天神（東）
    //    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=立花
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=七重
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=立花やぶなみ
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=新四ノ宮立花
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=早月
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=高岡
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=東四ノ宮
    //    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    Kyoukaisen=1
    //    .
    //    Eki.
    //    Ekimei=範馬（北）
    //    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=矢州
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=東四ノ宮
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=豊砂
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=大黒典東口
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=今津
    //    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    Kyoukaisen=1
    //    .
    //    Eki.
    //    Ekimei=長船(南)
    //    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=芦原
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=鯨井
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=南栄
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=小坂
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=宇多津
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=三保
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=折戸
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=矢田
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=木中
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=湊濱
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=桜志
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=大黒典
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=今津
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=坂出
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=大黒神宮
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=五十鈴
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=霧雨城
    //    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    Kyoukaisen=1
    //    .
    //    Eki.
    //    Ekimei=大黒典
    //    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=大黒典東口
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=笹原
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=二川
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=三郷島
    //    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    Kyoukaisen=1
    //    .
    //    Eki.
    //    Ekimei=東四ノ宮
    //    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=灘
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=四ノ宮
    //    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    Kyoukaisen=1
    //    .
    //    Eki.
    //    Ekimei=姫田(西)
    //    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    .
    //    Eki.
    //    Ekimei=未来
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=栗山
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=宮西
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=四ノ宮
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=桜町
    //    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    //    Ekikibo=Ekikibo_Ippan
    //    .
    //    Eki.
    //    Ekimei=湊濱
    //    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    //    Ekikibo=Ekikibo_Syuyou
    //    Kyoukaisen=1
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=普通
    //    Ryakusyou=普通
    //    JikokuhyouMojiColor=00000000
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=00000000
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=特急
    //    Ryakusyou=特急
    //    JikokuhyouMojiColor=000000FF
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=000000FF
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=快速
    //    Ryakusyou=快速
    //    JikokuhyouMojiColor=00FF0000
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=00FF0000
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=新快速
    //    Ryakusyou=新快速
    //    JikokuhyouMojiColor=000080FF
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=000080FF
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=貨物
    //    Ryakusyou=貨物
    //    JikokuhyouMojiColor=00000080
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=00000080
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Ressyasyubetsu.
    //    Syubetsumei=区間快速
    //    Ryakusyou=区快
    //    JikokuhyouMojiColor=00008000
    //    JikokuhyouFontIndex=0
    //    DiagramSenColor=00008000
    //    DiagramSenStyle=SenStyle_Jissen
    //    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    //    .
    //    Dia.
    //    DiaName=折戸線
    //    Kudari.
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=1
    //    Ressyabangou=1
    //    Ressyamei=月光
    //    EkiJikoku=,,,,,,,,,,,,,,1;151,2,2,1;245/247,2,2,2,1;322/324,2,2,2,2,1;415/417,2;431/,2,1;456/458,2,1;520/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=1
    //    Ressyabangou=3
    //    EkiJikoku=,,,,,,,,,,,,,,1;351,2,2,1;445/447,2,2,2,1;522/524,2,2,2,2,1;615/617,2;631/,2,1;656/658,2,1;720/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=3
    //    Ressyabangou=101A
    //    EkiJikoku=,,,,,,,,,,,,,,1;200,2,2,1;308/310,2,2,2,1;353/355,2,2,2,2,1;457/,3,3,3,3,3,1;459,1;510/512,2,2,1;604/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=3
    //    Ressyabangou=101B
    //    EkiJikoku=,,,,,,,,,,,,,,1;250,2,2,1;358/400,2,2,2,1;443/445,2,2,2,2,1;547/,3,3,3,3,3,1;549,1;600/602,2,2,1;654/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=2
    //    Ressyabangou=-2B
    //    EkiJikoku=,,,,,,,,,,,,,,1;112,2,2,1;220/222,1;239/241,1;252/254,1;304/306,1;316/330,2,2,1;409/411,2,1;437/,3,3,3,3,3,1;439,1;450/452,1;511/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=2
    //    Ressyabangou=201A
    //    EkiJikoku=,,,,,,,,,,,,,,1;219,2,2,1;327/329,1;346/348,1;359/401,1;411/413,1;423/425,2,2,1;504/506,2,1;532/,3,3,3,3,3,1;534,1;545/547,1;606/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=2
    //    Ressyabangou=201B
    //    EkiJikoku=,,,,,,,,,,,,,,1;312,2,2,1;420/422,1;439/441,1;452/454,1;504/506,1;516/530,2,2,1;609/611,2,1;637/,3,3,3,3,3,1;639,1;650/652,1;711/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=-2B
    //    EkiJikoku=,,,,,,,,,,,,,,1;037,1;118/120,1;134/136,1;152/206,1;223/225,1;236/238,1;248/250,1;301/303,1;315/317,1;329/331,1;349/417,1;430/432,1;446/,3,3,3,3,3,1;448,1;459/518,1;537/539,1;605/607,1;618/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=-2C
    //    EkiJikoku=,,,,,,,,,,,,,,1;121,1;202/204,1;218/220,1;236/252,1;309/311,1;322/324,1;334/336,1;347/401,1;413/415,1;427/429,1;447/449,1;502/504,1;518/,3,3,3,3,3,1;520,1;531/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=301D
    //    EkiJikoku=,,,,,,,,,,,,,,1;134,1;215/230,1;244/246,1;302/316,1;333/335,1;346/348,1;358/400,1;411/413,1;425/427,1;439/440,1;458/512,1;525/527,1;541/,3,3,3,3,3,1;543,1;554/608,1;627/629,1;655/657,1;708/
    //    Bikou=木中 1分停車
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=301A
    //    EkiJikoku=,,,,,,,,,,,,,,1;225,1;306/308,1;322/324,1;340/342,1;359/401,1;412/414,1;424/426,1;437/451,1;503/505,1;517/519,1;537/539,1;552/554,1;608/,3,3,3,3,3,1;610,1;621/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=301B
    //    EkiJikoku=,,,,,,,,,,,,,,1;237,1;318/320,1;334/336,1;352/406,1;423/425,1;436/438,1;448/450,1;501/503,1;515/517,1;529/531,1;549/617,1;630/632,1;646/,3,3,3,3,3,1;648,1;659/718,1;737/739,1;805/807,1;818/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=301C
    //    EkiJikoku=,,,,,,,,,,,,,,1;321,1;402/404,1;418/420,1;436/452,1;509/511,1;522/524,1;534/536,1;547/601,1;613/615,1;627/629,1;647/649,1;702/704,1;718/,3,3,3,3,3,1;720,1;731/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=301D
    //    EkiJikoku=,,,,,,,,,,,,,,1;334,1;415/430,1;444/446,1;502/516,1;533/535,1;546/548,1;558/600,1;611/613,1;625/627,1;639/640,1;658/712,1;725/727,1;741/,3,3,3,3,3,1;743,1;754/808,1;827/829,1;855/857,1;908/
    //    Bikou=木中 1分停車
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=4
    //    Ressyabangou=1F
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,2;1249/1249,2;1301/1301,2;1318/,3,3,3,3,3,2;1318,2;1327/1327
    //    Bikou=桜志～大黒典 速度設定「低速」、その他区間「中速」、019折戸貨タ発
    //    .
    //    Ressya.
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=1
    //    Ressyabangou=401
    //    Ressyamei=みなも
    //    EkiJikoku=1;222,2,2,2,1;322/324,2,2,2,3,3,2,2,1;410/412,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,1;446/448,2,1;510/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=1
    //    Ressyabangou=403
    //    EkiJikoku=1;422,2,2,2,1;522/524,2,2,2,3,3,2,2,1;610/612,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,1;646/648,2,1;710/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=3
    //    Ressyabangou=501A
    //    EkiJikoku=1;242,2,2,2,1;357/359,2,2,1;432/,3,3,1;434,2,1;458/500,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,1;542/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=3
    //    Ressyabangou=501B
    //    EkiJikoku=1;330,2,2,2,1;445/447,2,2,1;520/,3,3,1;522,2,1;546/548,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,1;630/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=3
    //    Ressyabangou=501A
    //    EkiJikoku=1;442,2,2,2,1;557/559,2,2,1;632/,3,3,1;634,2,1;658/700,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,1;742/744,2,1;811/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=2
    //    Ressyabangou=-2B
    //    EkiJikoku=1;204,1;245/257,2,2,1;333/335,2,2,1;408/,3,3,1;410,1;425/427,1;439/441,1;453/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=2
    //    Ressyabangou=601A
    //    EkiJikoku=1;302,1;343/345,2,2,1;421/423,2,2,1;456/,3,3,1;458,1;513/515,1;527/529,1;541/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=2
    //    Ressyabangou=601B
    //    EkiJikoku=1;404,1;445/457,2,2,1;533/535,2,2,1;608/,3,3,1;610,1;625/627,1;639/641,1;653/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=-2C
    //    EkiJikoku=1;112,1;153/155,1;205/207,1;222/224,1;239/253,1;304/306,1;318/324,1;338/,3,3,1;338/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;340,1;353/355,1;411/
    //    Bikou=高岡 停車6分
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=-2D
    //    EkiJikoku=1;149,1;230/232,1;242/244,1;259/301,1;316/341,1;352/354,1;406/408,1;422/,3,3,1;422/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;424,1;437/439,1;455/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=701A
    //    EkiJikoku=1;224,1;305/307,1;317/319,1;334/336,1;351/405,1;416/418,1;430/436,1;450/,3,3,1;450/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;452,1;505/507,1;523/
    //    Bikou=高岡 停車6分
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=701B
    //    EkiJikoku=1;248,1;329/331,1;341/343,1;358/400,1;415/429,1;440/442,1;454/456,1;510/,3,3,1;510/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;512,1;525/527,1;543/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=701C
    //    EkiJikoku=1;312,1;353/355,1;405/407,1;422/424,1;439/453,1;504/506,1;518/524,1;538/,3,3,1;538/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;540,1;553/555,1;611/
    //    Bikou=高岡 停車6分
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=701D
    //    EkiJikoku=1;349,1;430/432,1;442/444,1;459/501,1;516/541,1;552/554,1;606/608,1;622/,3,3,1;622/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;624,1;637/639,1;655/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=4
    //    Ressyabangou=401F
    //    EkiJikoku=1;344,2;417/417,2;428/428,2,2;503/503,2,2,2;545/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2;545,2,2;618/,3,3,3,3,2;618,2,2;655/
    //    Bikou=本線 速度設定「低速」
    //    .
    //    Ressya.
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=801R
    //    EkiJikoku=,,,,,,,,1;411,1;456/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=801A
    //    EkiJikoku=,,,,,,,,,1;418,1;442/444,1;458/500,1;512/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=801B
    //    EkiJikoku=,,,,,,,,,1;506,1;530/532,1;546/548,1;600/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=901A
    //    EkiJikoku=,,,,,,,,,,,,1;447,1;459/,3,3,3,3,3,3,3,3,3,3,3,3,3,1;501,1;521/523,1;536/546,1;559/601,1;616/
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=901B
    //    EkiJikoku=,,,,,,,,,,,,1;535,1;547/,3,3,3,3,3,3,3,3,3,3,3,3,3,1;549,1;609/611,1;624/634,1;647/649,1;704/
    //    .
    //    Ressya.
    //    .
    //    Ressya.
    //    .
    //    Ressya.
    //    Houkou=Kudari
    //    Syubetsu=0
    //    Ressyabangou=1001A
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1;335,1;419/421,1;438/440,1;501/503,1;522/527,1;542/544,1;600/
    //    .
    //    .
    //    Nobori.
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=1
    //    Ressyabangou=2
    //    Ressyamei=月光
    //    EkiJikoku=,,,,,,,,,,,,,,,1;410,2,1;432/434,2,2;459,1;513/515,2,2,2,2,1;605/607,2,2,2,1;642/644,2,2,1;737/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=1
    //    Ressyabangou=4
    //    EkiJikoku=,,,,,,,,,,,,,,,1;610,2,1;632/634,2,2;659,1;713/715,2,2,2,2,1;805/807,2,2,2,1;842/844,2,2,1;937/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=2
    //    Ressyabangou=-2B
    //    EkiJikoku=,,,,,,,,,,,,1;420,1;439/441,1;452/454,3,3,3,3,3,1;454,2,1;520/522,2,2,1;559/613,1;623/625,1;635/637,1;647/649,1;705/707,2,2,1;812/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=2
    //    Ressyabangou=202A
    //    EkiJikoku=,,,,,,,,,,,,1;526,1;545/547,1;558/600,3,3,3,3,3,1;600,2,1;626/628,2,2,1;705/707,1;717/719,1;729/731,1;741/743,1;759/801,2,2,1;906/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=2
    //    Ressyabangou=202B
    //    EkiJikoku=,,,,,,,,,,,,1;620,1;639/641,1;652/654,3,3,3,3,3,1;654,2,1;720/722,2,2,1;759/813,1;823/825,1;835/837,1;847/849,1;905/907,2,2,1;1012/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=3
    //    Ressyabangou=102A
    //    EkiJikoku=,,,,,,,,,,1;434,2,2,1;526/528,1;539/,3,3,3,3,3,1;541,2,2,2,2,1;643/645,2,2,2,1;728/730,2,2,1;835/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=3
    //    Ressyabangou=102B
    //    EkiJikoku=,,,,,,,,,,1;525,2,2,1;617/619,1;630/,3,3,3,3,3,1;632,2,2,2,2,1;734/736,2,2,2,1;819/821,2,2,1;926/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=-2D
    //    EkiJikoku=,,,,,,,,,,1;311,1;322/324,1;350/352,1;411/429,1;440/,3,3,3,3,3,1;442,1;456/458,1;511/541,1;559/601,1;612/614,1;626/628,1;638/640,1;650/652,1;703/705,1;722/736,1;752/754,1;809/811,1;849/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=302A
    //    EkiJikoku=,,,,,,,,,,,,,1;509,1;520/,3,3,3,3,3,1;522,1;536/538,1;551/553,1;611/613,1;624/626,1;638/652,1;702/704,1;714/716,1;727/729,1;746/748,1;804/806,1;821/823,1;901/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=302B
    //    EkiJikoku=,,,,,,,,,,1;420,1;431/433,1;459/501,1;520/538,1;549/,3,3,3,3,3,1;551,1;605/607,1;620/633,1;651/653,1;704/706,1;718/720,1;730/732,1;742/744,1;755/756,1;813/827,1;843/845,1;900/914,1;952/
    //    Bikou=小阪 停車1分
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=302C
    //    EkiJikoku=,,,,,,,,,,,,,1;559,1;610/,3,3,3,3,3,1;612,1;626/628,1;641/643,1;701/703,1;714/716,1;728/742,1;752/754,1;804/806,1;817/820,1;837/850,1;906/908,1;923/925,1;1003/
    //    Bikou=小阪 停車3分
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=202D
    //    EkiJikoku=,,,,,,,,,,1;511,1;522/524,1;550/552,1;611/629,1;640/,3,3,3,3,3,1;642,1;656/658,1;711/741,1;759/801,1;812/814,1;826/828,1;838/840,1;850/852,1;903/905,1;922/936,1;952/954,1;1009/1011,1;1049/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=4
    //    Ressyabangou=2F
    //    EkiJikoku=,,,,,,,,,,,,,2;827/827,2;846/,3,3,3,3,3,2;846,2;859/859,2;914/914
    //    Bikou=大黒典東口～大黒典 速度設定「超低速」、桜志～湊濱 「低速」、その他区間 「中速」、009笹原港貨駅発
    //    .
    //    Ressya.
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=1
    //    Ressyabangou=402
    //    Ressyamei=みなも
    //    EkiJikoku=,,,,,,,,,,,,,,,1;248,2,1;310/312,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1;347/349,2,2,3,3,2,2,2,1;436/438,2,2,2,1;537/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=1
    //    Ressyabangou=404
    //    EkiJikoku=,,,,,,,,,,,,,,,1;448,2,1;510/512,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1;547/549,2,2,3,3,2,2,2,1;636/638,2,2,2,1;737/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=3
    //    Ressyabangou=502A
    //    EkiJikoku=,,,,,,,,,,,,,,,,,1;326,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1;408/410,2,1;434/,3,3,1;436,2,2,1;512/514,2,2,2,1;629/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=3
    //    Ressyabangou=502B
    //    EkiJikoku=,,,,,,,,,,,,,,,,,1;414,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1;456/458,2,1;522/,3,3,1;524,2,2,1;600/602,2,2,2,1;717/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=3
    //    Ressyabangou=504A
    //    EkiJikoku=,,,,,,,,,,,,,,,1;457,2,1;524/526,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1;608/610,2,1;634/,3,3,1;636,2,2,1;712/714,2,2,2,1;829/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=2
    //    Ressyabangou=-2A
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1;303,1;315/317,1;329/331,1;346/,3,3,1;348,2,2,1;424/426,2,2,1;502/514,1;552/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=2
    //    Ressyabangou=602B
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1;415,1;427/429,1;441/443,1;458/,3,3,1;500,2,2,1;536/538,2,2,1;614/616,1;654/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=2
    //    Ressyabangou=602A
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1;503,1;515/517,1;529/531,1;546/,3,3,1;548,2,2,1;624/626,2,2,1;702/714,1;752/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=-2D
    //    EkiJikoku=,,,,,,,1;306,1;321/323,1;334/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;334/,3,3,1;336,1;351/353,1;405/407,1;418/444,1;458/500,1;516/518,1;528/530,1;608/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=702A
    //    EkiJikoku=,,,,,,,1;350,1;405/407,1;418/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;418/,3,3,1;424,1;439/441,1;453/455,1;506/520,1;534/536,1;552/554,1;604/606,1;644/
    //    Bikou=東四ノ宮 6分停車
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=702B
    //    EkiJikoku=,,,,,,,1;418,1;433/435,1;446/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;446/,3,3,1;448,1;503/505,1;517/519,1;530/544,1;558/600,1;616/618,1;628/630,1;708/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=702C
    //    EkiJikoku=,,,,,,,1;438,1;453/455,1;506/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;506/,3,3,1;512,1;527/529,1;541/543,1;554/608,1;622/624,1;640/642,1;652/654,1;732/
    //    Bikou=東四ノ宮 6分停車
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=702D
    //    EkiJikoku=,,,,,,,1;506,1;521/523,1;534/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1;534/,3,3,1;536,1;551/553,1;605/607,1;618/644,1;658/700,1;716/718,1;728/730,1;808/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=4
    //    Ressyabangou=402F
    //    EkiJikoku=2;305,2,2;343/,3,3,3,3,2;343,2,2;413/,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2;413,2,2,2;457/457,2,2;533/533,2;544/544,1;613/
    //    Bikou=本線 速度設定「低速」
    //    .
    //    Ressya.
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=802R
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1;501,1;546/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=802A
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1;355,1;407/409,1;424/426,1;450/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=802B
    //    EkiJikoku=,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,1;443,1;455/457,1;512/514,1;538/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=902A
    //    EkiJikoku=,,,,,,,,,,,,,,,1;253,1;308/310,1;323/332,1;346/348,1;407/,3,3,3,3,3,3,3,3,3,3,3,3,3,1;409,1;422/
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=902B
    //    EkiJikoku=,,,,,,,,,,,,,,,1;340,1;355/357,1;410/420,1;434/436,1;455/,3,3,3,3,3,3,3,3,3,3,3,3,3,1;457,1;510/
    //    .
    //    Ressya.
    //    .
    //    Ressya.
    //    Houkou=Nobori
    //    Syubetsu=0
    //    Ressyabangou=1002A
    //    EkiJikoku=1;512,1;527/529,1;546/551,1;610/612,1;632/634,1;652/654,1;735/737
    //    .
    //    .
    //    .
    //    KitenJikoku=000
    //    DiagramDgrYZahyouKyoriDefault=60
    //    Comment=
    //    .
    //    DispProp.
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Itaric=1
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1;Itaric=1
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    JikokuhyouVFont=PointTextHeight=9;Facename=@ＭＳ ゴシック
    //    DiaEkimeiFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    DiaJikokuFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    DiaRessyaFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    CommentFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    //    DiaMojiColor=00000000
    //    DiaHaikeiColor=00FFFFFF
    //    DiaRessyaColor=00000000
    //    DiaJikuColor=00C0C0C0
    //    EkimeiLength=6
    //    JikokuhyouRessyaWidth=5
    //    .
    //    FileTypeAppComment=Diagram Editor Ver. Alpha 1.0.0
    //    """

    static let mockOudText = """
    FileType=OuDia.1.02
    Rosen.
    Rosenmei=
    Eki.
    Ekimei=豊橋
    Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
    Ekikibo=Ekikibo_Syuyou
    .
    Eki.
    Ekimei=船町
    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    Ekikibo=Ekikibo_Ippan
    .
    Eki.
    Ekimei=下地
    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    Ekikibo=Ekikibo_Ippan
    .
    Eki.
    Ekimei=小坂井
    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    Ekikibo=Ekikibo_Ippan
    .
    Eki.
    Ekimei=牛久保
    Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
    Ekikibo=Ekikibo_Ippan
    .
    Eki.
    Ekimei=豊川
    Ekijikokukeisiki=Jikokukeisiki_KudariChaku
    Ekikibo=Ekikibo_Syuyou
    .
    Ressyasyubetsu.
    Syubetsumei=普通
    Ryakusyou=普通
    JikokuhyouMojiColor=00000000
    JikokuhyouFontIndex=0
    DiagramSenColor=00000000
    DiagramSenStyle=SenStyle_Jissen
    StopMarkDrawType=EStopMarkDrawType_DrawOnStop
    .
    Dia.
    DiaName=平日
    Kudari.
    Ressya.
    Houkou=Kudari
    Syubetsu=0
    Ressyabangou=437M
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1557,1;1559/1600,1;1601/1602,1;1605/1606,1;1608/1609,1;1613/
    .
    Ressya.
    Houkou=Kudari
    Syubetsu=0
    Ressyabangou=537G
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1612,2;,2;,1;1617/1618,1;1621/1622,1;1624/
    .
    Ressya.
    Houkou=Kudari
    Syubetsu=0
    Ressyabangou=439G
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1627,1;1629/1630,1;1631/1632,1;1635/1636,1;1638/1639,1;1642/
    .
    Ressya.
    Houkou=Kudari
    Syubetsu=0
    Ressyabangou=539M
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1642,2;,2;,1;1647/1648,1;1651/1652,1;1654/
    .
    Ressya.
    Houkou=Kudari
    Syubetsu=0
    Ressyabangou=441G
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1657,1;1659/1700,1;1701/1702,1;1705/1706,1;1708/1709,1;1713/
    .
    Ressya.
    Houkou=Kudari
    Syubetsu=0
    Ressyabangou=
    Ressyamei=
    Gousuu=
    EkiJikoku=3
    .
    Ressya.
    Houkou=Kudari
    Syubetsu=0
    Ressyabangou=
    Ressyamei=
    Gousuu=
    EkiJikoku=3
    .
    .
    Nobori.
    Ressya.
    Houkou=Nobori
    Syubetsu=0
    Ressyabangou=438G
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1549,1;1551/1552,1;1554/1555,1;1557/1558,1;1559/1600,1;1603/
    .
    Ressya.
    Houkou=Nobori
    Syubetsu=0
    Ressyabangou=544M
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1603,1;1606/1607,1;1609/1610,2;,2;,1;1616/
    .
    Ressya.
    Houkou=Nobori
    Syubetsu=0
    Ressyabangou=440M
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1618,1;1621/1622,1;1624/1625,1;1628/1629,1;1630/1631,1;1634/
    .
    Ressya.
    Houkou=Nobori
    Syubetsu=0
    Ressyabangou=546G
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1634,1;1636/1637,1;1639/1640,2;,2;,1;1646/
    .
    Ressya.
    Houkou=Nobori
    Syubetsu=0
    Ressyabangou=442G
    Ressyamei=
    Gousuu=
    EkiJikoku=1;1649,1;1651/1652,1;1655/1656,1;1659/1659,1;1701/1702,1;1705/
    .
    Ressya.
    Houkou=Nobori
    Syubetsu=0
    Ressyabangou=
    Ressyamei=
    Gousuu=
    EkiJikoku=3
    .
    Ressya.
    Houkou=Nobori
    Syubetsu=0
    Ressyabangou=
    Ressyamei=
    Gousuu=
    EkiJikoku=3
    .
    .
    .
    KitenJikoku=000
    DiagramDgrYZahyouKyoriDefault=60
    Comment=
    .
    DispProp.
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    JikokuhyouVFont=PointTextHeight=9;Facename=@ＭＳ ゴシック
    DiaEkimeiFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    DiaJikokuFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    CommentFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    DiaRessyaFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    DiaRessyaFont=PointTextHeight=9;Facename=ＭＳ ゴシック
    DiaMojiColor=00000000
    DiaHaikeiColor=00000000
    DiaRessyaColor=00FFFFFF
    DiaJikuColor=00000000
    DiaMojiColor=00C0C0C0
    EkimeiLength=6
    JikokuhyouRessyaWidth=5
    .
    FileTypeAppComment=CloudDia v0.4.3
    """
}
