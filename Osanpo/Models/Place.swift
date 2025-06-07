//
//  Place.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import Foundation
import SwiftData

@Model
class Place {
    var id: UUID
    var name: String
    var seasons: [Season]  // ← String → Season に変更！
    var months: [String]
    var memo: String?
    @Attribute(.externalStorage) var photoData: Data?
    var shouldNotify: Bool

    init(id: UUID = UUID(),
         name: String,
         seasons: [Season], // ← 型変更済み！
         months: [String],
         memo: String? = nil,
         photoData: Data? = nil,
         shouldNotify: Bool = false) {
        self.id = id
        self.name = name
        self.seasons = seasons
        self.months = months
        self.memo = memo
        self.photoData = photoData
        self.shouldNotify = shouldNotify
    }
}
