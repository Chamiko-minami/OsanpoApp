//
//  PlaceDetailView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/31.
//

import SwiftUI

struct PlaceDetailView: View {
    @Binding var place: Place
    @State private var isEditing = false

    var body: some View {
        ZStack {
            Image("sky_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 📍場所名
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color(hex: "3B4252"))
                        Text(place.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "3B4252"))
                    }

                    // 🗓️季節と月
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(hex: "3B4252"))
                            Text("いつ行きたい？")
                                .font(.headline)
                                .foregroundColor(Color(hex: "3B4252"))
                        }

                        // 季節アイコン
                        HStack {
                            ForEach(Array(place.seasons), id: \.self) { season in
                                Image(season.assetName)
                                    .resizable()
                                    .frame(width: 44, height: 44)
                            }
                        }

                        // 月アイコン（カスタム並び順）
                        let monthOrder = ["1月", "2月", "3月", "4月", "5月", "6月",
                                          "7月", "8月", "9月", "10月", "11月", "12月"]
                        HStack {
                            ForEach(place.months.sorted(by: {
                                guard let i1 = monthOrder.firstIndex(of: $0),
                                      let i2 = monthOrder.firstIndex(of: $1) else { return false }
                                return i1 < i2
                            }), id: \.self) { month in
                                Text(month)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 72)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("行きたい場所")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("編集") {
                    isEditing = true
                }
                .foregroundColor(Color(hex: "7C8894"))
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                PlaceInputView(placeToEdit: $place)
            }
        }
    }
}
