//  PlaceAddView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/31.

import SwiftUI
import SwiftData
import PhotosUI

struct PlaceAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTextFieldFocused: Bool

    @State private var placeName: String = ""
    @State private var selectedSeasons: Set<Season> = []
    @State private var selectedMonths: Set<String> = []
    @State private var memo: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Image("sky_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 340)
                    .overlay(
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                titleRow(icon: "mappin.and.ellipse", text: "行きたい場所")

                                TextField("例：井の頭公園", text: $placeName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .focused($isTextFieldFocused)

                                titleRow(icon: "calendar", text: "いつ行きたい？", subText: "行きたい季節・月を選択")

                                SeasonMonthPickerViewWrapper(
                                    selectedSeasons: $selectedSeasons,
                                    selectedMonths: $selectedMonths
                                )

                                titleRow(icon: "pencil", text: "メモ")

                                TextEditor(text: $memo)
                                    .frame(height: 100)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                    .focused($isTextFieldFocused)

                                titleRow(icon: "photo", text: "写真")

                                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                    HStack {
                                        Text("写真を選択")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(12)
                                }
                                .onChange(of: selectedPhotoItem) { _, newItem in
                                    if let newItem {
                                        Task {
                                            if let data = try? await newItem.loadTransferable(type: Data.self),
                                               let uiImage = UIImage(data: data) {
                                                selectedUIImage = uiImage
                                            }
                                        }
                                    }
                                }

                                if let uiImage = selectedUIImage {
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .cornerRadius(12)
                                            .padding(.top, 4)

                                        Button(action: {
                                            selectedUIImage = nil
                                            selectedPhotoItem = nil
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.gray.opacity(0.8))
                                                .padding(8)
                                        }
                                    }
                                }

                                Spacer(minLength: 40)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                            .padding(.bottom, 80)
                        }
                        .keyboardAvoiding()
                    )
            }
            .navigationBarTitleDisplayMode(.inline)
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
                    Button(action: savePlace) {
                        Text("保存")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color(hex: "7C8894"))
                }

                ToolbarItem(placement: .principal) {
                    Text("行きたい場所を登録")
                        .font(.headline)
                        .foregroundColor(Color(hex: "7C8894"))
                }
            }
            .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .onAppear {
                let currentMonthNumber = Calendar.current.component(.month, from: Date())
                let currentMonthString = "\(currentMonthNumber)月"

                if let currentSeason = Season.forMonth(currentMonthString) {
                    selectedMonths = [currentMonthString]
                    selectedSeasons = [currentSeason]
                }
            }
        }
    }

    private func savePlace() {
        var monthsToSave = selectedMonths
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if monthsToSave.isEmpty {
            monthsToSave = ["\(Calendar.current.component(.month, from: Date()))月"]
        }

        let newPlace = Place(
            name: placeName,
            seasons: selectedSeasons.map { $0.rawValue },
            months: monthsToSave,
            memo: memo,
            imageData: selectedUIImage?.jpegData(compressionQuality: 0.8)
        )

        print("DEBUG: Saving place → name: \(newPlace.name), months: \(newPlace.months), seasons: \(newPlace.seasons)")

        modelContext.insert(newPlace)

        do {
            try modelContext.save()
            print("DEBUG: modelContext.save() SUCCESS ✅")
        } catch {
            print("ERROR: modelContext.save() failed → \(error)")
        }

        dismiss()
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
}
