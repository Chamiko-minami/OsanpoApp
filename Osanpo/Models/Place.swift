//
//  Place.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/08.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Place: Identifiable {
    @Attribute(.unique) var id: UUID = UUID() // ⭐️ 追加 → ForEach が正しく動くために必要！！！

    var name: String // 行きたい場所の名前
    var seasons: [String] = [] // 行きたい季節（春・夏・秋・冬など）
    var months: [String] = [] // 行きたい月（"1月", "2月", ...）
    var memo: String? // メモ
    @Attribute(.externalStorage) var imageData: Data? // 写真
    
    init(name: String, seasons: [String] = [], months: [String] = [], memo: String? = nil, imageData: Data? = nil) {
        self.id = UUID() // ⭐️ 初期化時にUUIDを自動で設定
        self.name = name
        self.seasons = seasons
        self.months = months
        self.memo = memo
        self.imageData = imageData
    }
}
