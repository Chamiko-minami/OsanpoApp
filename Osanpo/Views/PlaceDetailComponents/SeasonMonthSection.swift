//
//  SeasonMonthSection.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct SeasonMonthSection: View {
    let seasons: Set<Season>
    let months: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 見出し
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundColor(Color(hex: "3B4252"))
                Text("いつ行きたい？")
                    .font(.headline)
                    .foregroundColor(Color(hex: "3B4252"))
            }

            // 季節アイコン
            HStack {
                ForEach(Array(Season.allCases), id: \.self) { season in
                    if seasons.contains(season) {
                        Image(season.assetName)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
            }

            // 月（カスタム並び順）
            let monthOrder = ["1月", "2月", "3月", "4月", "5月", "6月",
                              "7月", "8月", "9月", "10月", "11月", "12月"]
            let sortedMonths = months.sorted { a, b in
                guard let i1 = monthOrder.firstIndex(of: a),
                      let i2 = monthOrder.firstIndex(of: b) else { return false }
                return i1 < i2
            }

            HStack {
                ForEach(sortedMonths, id: \.self) { month in
                    Text(month)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.75))
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
