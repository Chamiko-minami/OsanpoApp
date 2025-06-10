//
//  SeasonMonthPickerView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct SeasonMonthPickerView: View {
    @Binding var selectedSeasons: Set<Season>
    @Binding var selectedMonths: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 季節アイコンと月をグリッド状に配置
            HStack(alignment: .top, spacing: 16) {
                ForEach(Season.allCases, id: \.self) { season in
                    VStack(spacing: 8) {
                        // 季節アイコン（45×45に変更！）
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
                                .frame(width: 45, height: 45) // ← ★ 45×45 に変更！
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

                        // 月ボタン（frame(width: 45)に変更！）
                        VStack(spacing: 8) {
                            ForEach(season.months, id: \.self) { month in
                                let isSelected = selectedMonths.contains(month)
                                
                                Button(action: {
                                    if isSelected {
                                        selectedMonths.remove(month)
                                        
                                        // ★ 追加：その季節の月が全部非選択なら、季節も選択解除する
                                        let remainingSelectedMonthsInSeason = season.months.filter { selectedMonths.contains($0) }
                                        if remainingSelectedMonthsInSeason.isEmpty {
                                            selectedSeasons.remove(season)
                                        }
                                        
                                    } else {
                                        selectedMonths.insert(month)
                                        selectedSeasons.insert(season)
                                    }
                                }) {
                                    Text(month)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(hex: "676666").opacity(isSelected ? 1.0 : 0.2))
                                        .frame(width: 45) // ← ★ 45 に変更！
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10) // ← あなたの最新版通り cornerRadius 10 にする！
                                                .fill(Color(hex: season.bgColor).opacity(isSelected ? 1.0 : 0.3))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10) // ← overlay 側も 10 に揃える！
                                                .inset(by: 0.5)
                                                .stroke(Color(hex: season.borderColor), lineWidth: isSelected ? 1 : 0)
                                        )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
