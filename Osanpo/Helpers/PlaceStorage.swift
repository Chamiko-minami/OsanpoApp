//
//  PlaceStorage.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import Foundation

class PlaceStorage {
    private let key = "places"

    // 保存
    func save(_ places: [Place]) {
        if let data = try? JSONEncoder().encode(places) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // 読み込み
    func load() -> [Place] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let places = try? JSONDecoder().decode([Place].self, from: data) else {
            return []
        }
        return places
    }

    // 追加保存（今あるデータに追加）
    func add(_ newPlace: Place) {
        var places = load()
        places.append(newPlace)
        save(places)
    }
}
