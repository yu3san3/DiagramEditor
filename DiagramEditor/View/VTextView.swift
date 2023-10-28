//
//  VTextView.swift
//  DiagramEditor
//
//  Created by 丹羽雄一朗 on 2023/05/31.
//

import SwiftUI

//https://qiita.com/fuziki/items/b31055a69330a3ce55a5#:~:text=SwiftUI%E3%81%A7%E7%B8%A6%E6%9B%B8%E3%81%8D%E3%82%92%E5%AE%9F%E7%8F%BE%E3%81%99%E3%82%8BTategakiText%201%20%E5%8B%95%E4%BD%9C%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%20text%E3%82%92%E6%B8%A1%E3%81%99%E3%81%A8%E7%B8%A6%E6%9B%B8%E3%81%8D%E8%A1%A8%E7%A4%BA%E3%81%95%E3%82%8C%E3%81%BE%E3%81%99%E3%80%82%20%E3%82%AB%E3%82%AE%E3%81%8B%E3%81%A3%E3%81%93%E3%82%84%E3%80%81%E3%83%93%E3%83%83%E3%82%AF%E3%83%AA%E3%82%84%E3%83%8F%E3%83%86%E3%83%8A%E8%A8%98%E5%8F%B7%E3%80%81%EF%BC%93%E7%82%B9%E3%83%AA%E3%83%BC%E3%83%80%E3%83%BC%E3%81%AA%E3%81%A9%E3%82%82%E7%B8%A6%E6%9B%B8%E3%81%8D%E3%81%AB%E5%90%88%E3%82%8F%E3%81%9B%E3%81%9F%E8%A1%A8%E7%A4%BA%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E3%81%84%E3%81%BE%E3%81%99%E3%80%82%202%20%E3%82%BD%E3%83%BC%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%89%203,%E3%81%B5%E3%81%98%E3%81%8D%20%28%40fzkqi%29%20April%2018%2C%202020%20TategakiText%20TategakiText%20

extension View {
    @ViewBuilder
    func VText(_ text: String) -> some View {
        VStack(spacing: 0) {
            //FIXME: - idをselfにしていることで、重複する可能性がある
            ForEach (Array(text), id: \.self) { str in
                Text(String(str))
            }
        }
    }
}
