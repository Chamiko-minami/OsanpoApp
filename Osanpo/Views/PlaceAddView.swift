//
//  PlaceAddView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct PlaceAddView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool

    @State private var placeName: String = ""
    @State private var selectedSeasons: Set<Season> = []
    @State private var selectedMonths: Set<String> = []

    var body: some View {
        ZStack {
            Image("sky_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 340, height: 600)
                    .overlay(
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                // 📍 行きたい場所
                                HStack(spacing: 6) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(Color(hex: "3B4252"))
                                    Text("行きたい場所")
                                        .font(.headline)
                                        .foregroundColor(Color(hex: "3B4252"))
                                }

                                TextField("例：井の頭公園", text: $placeName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .focused($isTextFieldFocused)

                                // 🗓️ いつ行きたい？
                                HStack(spacing: 6) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color(hex: "3B4252"))
                                    Text("いつ行きたい？")
                                        .font(.headline)
                                        .foregroundColor(Color(hex: "3B4252"))
                                    Text("行きたい季節・月を選択")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                SeasonMonthPickerViewWrapper(
                                    selectedSeasons: $selectedSeasons,
                                    selectedMonths: $selectedMonths
                                )

                                Spacer(minLength: 40)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                            .padding(.bottom, 80)
                        }
                        .frame(width: 340, height: 600)
                        .keyboardAvoiding()
                    )
            }
        }
        .navigationTitle("行きたい場所を登録")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("リスト")
                    }
                    .foregroundColor(Color(hex: "7C8894"))
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: savePlace) {
                    Text("保存")
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .foregroundColor(Color(hex: "7C8894"))
            }
        }
    }

    private func savePlace() {
        let newPlace = Place(
            id: UUID(),
            name: placeName,
            seasons: selectedSeasons,
            months: Array(selectedMonths),
            memo: nil,
            photoData: nil,
            shouldNotify: false
        )

        var currentPlaces: [Place] = []
        if let data = UserDefaults.standard.data(forKey: "savedPlaces"),
           let decoded = try? JSONDecoder().decode([Place].self, from: data) {
            currentPlaces = decoded
        }

        currentPlaces.append(newPlace)

        if let encoded = try? JSONEncoder().encode(currentPlaces) {
            UserDefaults.standard.set(encoded, forKey: "savedPlaces")
        }

        dismiss()
    }
}
