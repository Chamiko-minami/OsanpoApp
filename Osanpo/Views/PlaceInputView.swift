//
//  PlaceInputView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/31.
//

import SwiftUI

struct PlaceInputView: View {
    @Binding var placeToEdit: Place
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool

    @State private var placeName: String = ""
    @State private var selectedSeasons: Set<Season> = []
    @State private var selectedMonths: Set<String> = []

    var body: some View {
        VStack(spacing: 0) {
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

                                    HStack(spacing: 6) {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("いつ行きたい？")
                                            .font(.headline)
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("行きたい季節・月を選択")
                                            .font(.footnote)
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
        }
        .navigationBarBackButtonHidden(true)
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

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: saveChanges) {
                    Text("保存")
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .foregroundColor(Color(hex: "7C8894"))
            }

            ToolbarItem(placement: .principal) {
                Text("行きたい場所を登録")
                    .font(.headline)
                    .foregroundColor(Color(hex: "7C8894"))
            }
        }
        .onAppear {
            placeName = placeToEdit.name
            selectedSeasons = Set(placeToEdit.seasons.compactMap { Season(rawValue: $0) })
            selectedMonths = Set(placeToEdit.months)
        }
    }

    private func saveChanges() {
        placeToEdit.name = placeName
        placeToEdit.seasons = selectedSeasons.map { $0.rawValue }
        placeToEdit.months = Array(selectedMonths)
        dismiss()
    }
}
