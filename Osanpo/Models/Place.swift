//
//  Models:Place.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import Foundation

struct Place: Identifiable, Codable {
    var id: UUID
    var name: String
    var seasons: Set<Season>
    var months: [String]
    var memo: String?
    var photoData: Data?
    var shouldNotify: Bool
}
