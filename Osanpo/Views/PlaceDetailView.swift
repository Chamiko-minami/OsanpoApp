//  PlaceDetailView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.

import SwiftUI
import SwiftData

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var place: Place

    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 80)

                    // 行きたい場所名
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color(hex: "3B4252").opacity(0.8))
                        Text(place.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "3B4252").opacity(0.8))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 5)
                    .padding(.bottom, 16)

                    VStack(alignment: .leading, spacing: 16) {
                        // 🗓️ いつ行きたい？
                        titleRow(icon: "calendar", text: "いつ行きたい？", subText: "行きたい季節・月を選択")

                        // 季節アイコン
                        HStack(spacing: 12) {
                            ForEach(["春", "夏", "秋", "冬"], id: \.self) { season in
                                let info = seasonColorInfo(for: season)
                                let isSelected = place.seasons.contains(season)

                                Image(info.assetName)
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .padding(6)
                                    .background(Color(hex: info.backgroundColor).opacity(isSelected ? 1.0 : 0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isSelected ? Color(hex: info.borderColor) : .clear, lineWidth: isSelected ? 1 : 0)
                                    )
                                    .opacity(isSelected ? 1.0 : 0.3)
                            }
                        }
                        .padding(.horizontal, 24)

                        // 月アイコン
                        let monthOrder = ["1月", "2月", "3月", "4月", "5月", "6月",
                                          "7月", "8月", "9月", "10月", "11月", "12月"]

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(monthOrder, id: \.self) { month in
                                    let season = seasonForMonth(month)
                                    let isSelected = place.months.contains(month)

                                    Text(month)
                                        .font(.footnote)
                                        .foregroundColor(Color(hex: "676666").opacity(isSelected ? 1.0 : 0.3))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(hex: season.backgroundColor).opacity(isSelected ? 1.0 : 0.3))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(isSelected ? Color(hex: season.borderColor) : .clear,
                                                                lineWidth: isSelected ? 0.5 : 0)
                                                )
                                        )
                                }
                            }
                            .padding(.horizontal, 24)
                        }

                        // メモ
                        titleRow(icon: "pencil", text: "メモ")

                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.6))
                                .frame(height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )

                            if let memoText = place.memo, !memoText.isEmpty {
                                Text(memoText)
                                    .foregroundColor(Color(hex: "3B4252").opacity(0.8))
                                    .padding(14)
                            } else {
                                Text("メモはありません")
                                    .foregroundColor(Color.gray.opacity(0.6))
                                    .padding(14)
                            }
                        }
                        .padding(.horizontal, 24)

                        // 写真
                        titleRow(icon: "photo", text: "写真")

                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.6))
                                .frame(height: 200)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )

                            if let imageData = place.imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .cornerRadius(12)
                                    .padding(10)
                            } else {
                                Text("写真はありません")
                                    .foregroundColor(Color.gray.opacity(0.6))
                            }
                        }
                        .padding(.horizontal, 24)

                        Spacer(minLength: 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.6))
                    )
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("リスト")
                        }
                        .foregroundColor(Color(hex: "7C8894"))
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("行きたい場所")
                        .foregroundColor(Color(hex: "7C8894"))
                        .font(.headline)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing = true
                    }) {
                        Text("編集")
                            .foregroundColor(Color(hex: "7C8894"))
                            .font(.body)
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                PlaceEditView(place: place) {
                    dismiss()
                }
            }
        }
    }

    // 背景
    private var backgroundView: some View {
        Image("sky_background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    // タイトル行共通化
    @ViewBuilder
    private func titleRow(icon: String, text: String, subText: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "3B4252"))
                Text(text)
                    .font(.headline)
                    .foregroundColor(Color(hex: "3B4252"))
            }
            if let sub = subText {
                Text(sub)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading, 28)
            }
        }
    }

    // 色設定
    private func seasonColorInfo(for season: String) -> (backgroundColor: String, borderColor: String, assetName: String) {
        switch season {
        case "春": return ("FFD1DC", "EB8FA9", "haru_icon")
        case "夏": return ("FFF4B3", "F1C93B", "natsu_icon")
        case "秋": return ("FFC8A2", "E38B4D", "aki_icon")
        case "冬": return ("A6D8E4", "6BAACD", "fuyu_icon")
        default:   return ("CCCCCC", "999999", "")
        }
    }

    private func seasonForMonth(_ month: String) -> (backgroundColor: String, borderColor: String) {
        switch month {
        case "3月", "4月", "5月":   return ("FFD1DC", "EB8FA9")
        case "6月", "7月", "8月":   return ("FFF4B3", "F1C93B")
        case "9月", "10月", "11月": return ("FFC8A2", "E38B4D")
        case "12月", "1月", "2月":  return ("A6D8E4", "6BAACD")
        default:                    return ("CCCCCC", "999999")
        }
    }
}
