//
//  DiagramEditorTests.swift
//  DiagramEditorTests
//
//  Created by 丹羽雄一朗 on 2023/07/20.
//

import XCTest
@testable import DiagramEditor

final class DiagramEditorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOudParser() throws {
        let testData = """
        FileType=OuDia.1.02
        Rosen.
        Rosenmei=
        Eki.
        Ekimei=A駅
        Ekijikokukeisiki=Jikokukeisiki_NoboriChaku
        Ekikibo=Ekikibo_Ippan
        .
        Eki.
        Ekimei=B駅
        Ekijikokukeisiki=Jikokukeisiki_Hatsuchaku
        Ekikibo=Ekikibo_Ippan
        .
        Eki.
        Ekimei=C駅
        Ekijikokukeisiki=Jikokukeisiki_KudariChaku
        Ekikibo=Ekikibo_Ippan
        .
        Ressyasyubetsu.
        Syubetsumei=普通
        Ryakusyou=
        JikokuhyouMojiColor=00000000
        JikokuhyouFontIndex=0
        DiagramSenColor=00000000
        DiagramSenStyle=SenStyle_Jissen
        StopMarkDrawType=EStopMarkDrawType_DrawOnStop
        .
        Ressyasyubetsu.
        Syubetsumei=特別急行
        Ryakusyou=特急
        JikokuhyouMojiColor=000000FF
        JikokuhyouFontIndex=0
        DiagramSenColor=000000FF
        DiagramSenStyle=SenStyle_Jissen
        StopMarkDrawType=EStopMarkDrawType_DrawOnStop
        .
        Dia.
        DiaName=例
        Kudari.
        Ressya.
        Houkou=Kudari
        Syubetsu=0
        Ressyabangou=101
        EkiJikoku=1;800,1;810/815,1;830/
        .
        Ressya.
        Houkou=Kudari
        Syubetsu=1
        Ressyabangou=1
        EkiJikoku=1;805,2,1;825/
        .
        .
        Nobori.
        .
        .
        Dia.
        DiaName=例2
        Kudari.
        Ressya.
        Houkou=Kudari
        Syubetsu=0
        Ressyabangou=101
        EkiJikoku=1;800,1;810/815,1;830/
        .
        .
        Nobori.
        Ressya.
        Houkou=Nobori
        Syubetsu=0
        Ressyabangou=102
        EkiJikoku=1;800,1;810/815,1;830/
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
        JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Itaric=1
        JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1;Itaric=1
        JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        JikokuhyouFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        JikokuhyouVFont=PointTextHeight=9;Facename=@ＭＳ ゴシック
        DiaEkimeiFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        DiaJikokuFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        DiaRessyaFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        CommentFont=PointTextHeight=9;Facename=ＭＳ ゴシック
        DiaMojiColor=00000000
        DiaHaikeiColor=00FFFFFF
        DiaRessyaColor=00000000
        DiaJikuColor=00C0C0C0
        EkimeiLength=6
        JikokuhyouRessyaWidth=5
        .
        FileTypeAppComment=Diagram Editor Ver. Alpha 1.0.0
        """

        let expectedData = OudData(fileType: "OuDia.1.02", rosen: Rosen(rosenmei: "", eki: [Eki(ekimei: "A駅", ekijikokukeisiki: Ekijikokukeisiki.noboriChaku, ekikibo: "Ekikibo_Ippan", kyoukaisen: "", diagramRessyajouhouHyoujiKudari: "", diagramRessyajouhouHyoujiNobori: ""), Eki(ekimei: "B駅", ekijikokukeisiki: Ekijikokukeisiki.hatsuchaku, ekikibo: "Ekikibo_Ippan", kyoukaisen: "", diagramRessyajouhouHyoujiKudari: "", diagramRessyajouhouHyoujiNobori: ""), Eki(ekimei: "C駅", ekijikokukeisiki: Ekijikokukeisiki.kudariChaku, ekikibo: "Ekikibo_Ippan", kyoukaisen: "", diagramRessyajouhouHyoujiKudari: "", diagramRessyajouhouHyoujiNobori: "")], ressyasyubetsu: [Ressyasyubetsu(syubetsumei: "普通", ryakusyou: "", jikokuhyouMojiColor: "00000000", jikokuhyouFontIndex: "0", diagramSenColor: "00000000", diagramSenStyle: "SenStyle_Jissen", diagramSenIsBold: "", stopMarkDrawType: "EStopMarkDrawType_DrawOnStop"), Ressyasyubetsu(syubetsumei: "特別急行", ryakusyou: "特急", jikokuhyouMojiColor: "000000FF", jikokuhyouFontIndex: "0", diagramSenColor: "000000FF", diagramSenStyle: "SenStyle_Jissen", diagramSenIsBold: "", stopMarkDrawType: "EStopMarkDrawType_DrawOnStop")], dia: [Dia(diaName: "例", kudari: Kudari(ressya: [Ressya(houkou: "Kudari", syubetsu: 0, ressyabangou: "101", ressyamei: "", gousuu: "", ekiJikoku: ["1;800", "1;810/815", "1;830/"], bikou: ""), Ressya(houkou: "Kudari", syubetsu: 1, ressyabangou: "1", ressyamei: "", gousuu: "", ekiJikoku: ["1;805", "2", "1;825/"], bikou: "")]), nobori: Nobori(ressya: [])), Dia(diaName: "例2", kudari: Kudari(ressya: [Ressya(houkou: "Kudari", syubetsu: 0, ressyabangou: "101", ressyamei: "", gousuu: "", ekiJikoku: ["1;800", "1;810/815", "1;830/"], bikou: "")]), nobori: Nobori(ressya: [Ressya(houkou: "Nobori", syubetsu: 0, ressyabangou: "102", ressyamei: "", gousuu: "", ekiJikoku: ["1;800", "1;810/815", "1;830/"], bikou: "")]))], kitenJikoku: "000", diagramDgrYZahyouKyoriDefault: "60", comment: ""), dispProp: DispProp(jikokuhyouFont: ["PointTextHeight=9;Facename=ＭＳ ゴシック", "PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1", "PointTextHeight=9;Facename=ＭＳ ゴシック;Itaric=1", "PointTextHeight=9;Facename=ＭＳ ゴシック;Bold=1;Itaric=1", "PointTextHeight=9;Facename=ＭＳ ゴシック", "PointTextHeight=9;Facename=ＭＳ ゴシック", "PointTextHeight=9;Facename=ＭＳ ゴシック", "PointTextHeight=9;Facename=ＭＳ ゴシック"], jikokuhyouVFont: "PointTextHeight=9;Facename=@ＭＳ ゴシック", diaEkimeiFont: "PointTextHeight=9;Facename=ＭＳ ゴシック", diaJikokuFont: "PointTextHeight=9;Facename=ＭＳ ゴシック", diaRessyaFont: "PointTextHeight=9;Facename=ＭＳ ゴシック", commentFont: "PointTextHeight=9;Facename=ＭＳ ゴシック", diaMojiColor: "00000000", diaHaikeiColor: "00FFFFFF", diaRessyaColor: "00000000", diaJikuColor: "00C0C0C0", ekimeiLength: "6", jikokuhyouRessyaWidth: "5"), fileTypeAppComment: "Diagram Editor Ver. Alpha 1.0.0")

        let parsedData = OuDia.parse(testData)
        XCTAssertEqual(parsedData, expectedData)

        let stringifiedData = OuDia.stringify(expectedData)
        XCTAssertEqual(testData, stringifiedData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
