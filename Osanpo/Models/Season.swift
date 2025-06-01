//
//  Models:Season.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

enum Season: String, CaseIterable, Codable {
    case spring = "春"
    case summer = "夏"
    case autumn = "秋"
    case winter = "冬"

    var months: [String] {
        switch self {
        case .spring: return ["3月", "4月", "5月"]
        case .summer: return ["6月", "7月", "8月"]
        case .autumn: return ["9月", "10月", "11月"]
        case .winter: return ["1月", "2月", "12月"]
        }
    }

    var assetName: String {
        switch self {
        case .spring: return "haru_icon"
        case .summer: return "natsu_icon"
        case .autumn: return "aki_icon"
        case .winter: return "fuyu_icon"
        }
    }

    var bgColor: String {
        switch self {
        case .spring: return "FFD1DC"
        case .summer: return "FFF4B3"
        case .autumn: return "FFC8A2"
        case .winter: return "A6D8E4"
        }
    }

    var borderColor: String {
        switch self {
        case .spring: return "EB8FA9"
        case .summer: return "F1C93B"
        case .autumn: return "E38B4D"
        case .winter: return "6BAACD"
        }
    }

    static func forMonth(_ month: String) -> Season? {
        switch month {
        case "3月", "4月", "5月": return .spring
        case "6月", "7月", "8月": return .summer
        case "9月", "10月", "11月": return .autumn
        case "12月", "1月", "2月": return .winter
        default: return nil
        }
    }
}
