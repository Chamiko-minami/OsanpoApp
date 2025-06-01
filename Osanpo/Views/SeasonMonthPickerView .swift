//
//  SeasonMonthPickerView .swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct SeasonMonthPickerView: View {
    @Binding var selectedSeasons: Set<Season>
    @Binding var selectedMonths: Set<String>

    let allMonths = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]

    var body: some View {
        VStack(spacing: 24) {
            // 季節アイコン行
            HStack(spacing: 16) {
                ForEach(Season.allCases, id: \.self) { season in
                    let isSelected = selectedSeasons.contains(season)
                    Button(action: {
                        if isSelected {
                            selectedSeasons.remove(season)
                            selectedMonths.subtract(season.months)
                        } else {
                            selectedSeasons.insert(season)
                            selectedMonths.formUnion(season.months)
                        }
                    }) {
                        Image(season.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                            .opacity(isSelected ? 1.0 : 0.3)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: season.bgColor).opacity(isSelected ? 1.0 : 0.3))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .inset(by: 0.5)
                                    .stroke(Color(hex: season.borderColor), lineWidth: isSelected ? 1 : 0)
                            )
                    }
                }
            }
            .padding(.leading, 8) // 左寄せ調整

            // 月のボタン（横並び、サイズ固定）
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(allMonths, id: \.self) { month in
                        let isSelected = selectedMonths.contains(month)
                        let season = Season.forMonth(month)

                        Button(action: {
                            if isSelected {
                                selectedMonths.remove(month)
                            } else {
                                selectedMonths.insert(month)
                                if let season = season {
                                    selectedSeasons.insert(season)
                                }
                            }
                        }) {
                            Text(month)
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "676666").opacity(isSelected ? 1.0 : 0.2))
                                .frame(width: 48) // サイズ固定！！
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: season?.bgColor ?? "DDDDDD").opacity(isSelected ? 1.0 : 0.3))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .inset(by: 0.5)
                                        .stroke(Color(hex: season?.borderColor ?? "AAAAAA"), lineWidth: isSelected ? 1 : 0)
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
}
