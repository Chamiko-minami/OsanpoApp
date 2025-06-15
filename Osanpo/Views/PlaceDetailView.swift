// PlaceDetailView.swift
// Osanpo
//
// Created by 酒井みな実 on 2025/06/01.

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

                VStack(spacing: 0) {
                    Spacer().frame(height: 80)

                    // 白背景枠
                    VStack(alignment: .leading, spacing: 20) {

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
                        .padding(.top, 5)
                        .padding(.bottom, 16)

                        // 🗓️ いつ行きたい？
                        titleRow(icon: "calendar", text: "いつ行きたい？", subText: "行きたい季節・月を選択")

                        // 季節・月選択(表示のみ)
                        SeasonMonthPickerViewWrapper(
                            selectedSeasons: .constant(Set(place.seasons.compactMap { Season(rawValue: $0) })),
                            selectedMonths: .constant(Set(place.months))
                        )
                        .allowsHitTesting(false)
                        .padding(.horizontal, 24)

                        // メモ
                        titleRow(icon: "pencil", text: "メモ")
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.6))
                                .frame(height: 60)
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
                            if let memo = place.memo, !memo.isEmpty {
                                Text(memo)
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
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1))
                            if let data = place.imageData, let uiImage = UIImage(data: data) {
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
                    }
                    .frame(maxWidth: 340)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    .background(RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.6)))
                    .padding(.horizontal)

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
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("リスト")
                        }
                        .foregroundColor(Color(hex: "7C8894"))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("行きたい場所")
                        .font(.headline)
                        .foregroundColor(Color(hex: "7C8894"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isEditing = true }) {
                        Text("編集")
                            .font(.body)
                            .foregroundColor(Color(hex: "7C8894"))
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

    private var backgroundView: some View {
        Image("sky_background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

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
}
