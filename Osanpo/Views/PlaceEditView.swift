//
//  PlaceEditView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI
import PhotosUI
import SwiftData

struct PlaceEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var place: Place

    @State private var placeName: String = ""
    @State private var selectedSeasons: Set<Season> = []
    @State private var selectedMonths: Set<String> = []
    @State private var memo: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var showDeleteAlert = false
    @State private var showPhotoPicker = false

    var onSave: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Image("sky_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.75))
                        .frame(width: 340)
                        .overlay(
                            ScrollView {
                                VStack(alignment: .leading, spacing: 20) {
                                    // 📍 行きたい場所
                                    titleRow(icon: "mappin.and.ellipse", text: "行きたい場所")

                                    TextField("例：井の頭公園", text: $placeName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    // 🗓️ いつ行きたい？
                                    titleRow(icon: "calendar", text: "いつ行きたい？", subText: "行きたい季節・月を選択")

                                    SeasonMonthPickerViewWrapper(
                                        selectedSeasons: $selectedSeasons,
                                        selectedMonths: $selectedMonths
                                    )

                                    // ✒️ メモ
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

                                    // 📸 写真
                                    titleRow(icon: "photo", text: "写真")

                                    Button(action: {
                                        showPhotoPicker = true
                                    }) {
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
                                    .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem, matching: .images)
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

                                    // 登録済み写真があれば表示＋×ボタン
                                    if let uiImage = selectedUIImage ?? (place.imageData.flatMap { UIImage(data: $0) }) {
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 150)
                                                .cornerRadius(12)
                                                .padding(.top, 4)

                                            Button(action: {
                                                selectedUIImage = nil
                                                place.imageData = nil
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.gray.opacity(0.8))
                                                    .padding(8)
                                            }
                                        }
                                    }

                                    Spacer(minLength: 20)

                                    // 削除ボタン
                                    Button(action: {
                                        showDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("この場所を削除")
                                        }
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(Color(hex: "FF7F7F"))
                                        .background(Color.white.opacity(0.6))
                                        .cornerRadius(12)
                                    }
                                    .padding(.bottom, 16)
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 32)
                                .padding(.bottom, 40)
                            }
                            .keyboardAvoiding()
                        )
                }
            }
            .navigationBarTitleDisplayMode(.inline) // ⭐️ これを入れる → ナビバー短くなる！！
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("戻る")
                        }
                        .foregroundColor(Color(hex: "7C8894"))
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveChanges) {
                        Text("保存")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(Color(hex: "7C8894"))
                }

                ToolbarItem(placement: .principal) {
                    Text("行きたい場所を編集")
                        .font(.headline)
                        .foregroundColor(Color(hex: "7C8894"))
                }
            }
            .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar) // ⭐️ 黄色背景＋表示復活
            .toolbarColorScheme(.light, for: .navigationBar)
            .onAppear {
                placeName = place.name
                selectedSeasons = Set(place.seasons.compactMap { Season(rawValue: $0) })
                selectedMonths = Set(place.months)
                memo = place.memo ?? ""

                if let imageData = place.imageData,
                   let uiImage = UIImage(data: imageData) {
                    selectedUIImage = uiImage
                }
            }
            .alert("この場所を削除しますか？", isPresented: $showDeleteAlert) {
                Button("削除", role: .destructive) {
                    deletePlace()
                }
                Button("キャンセル", role: .cancel) { }
            }
        }
    }

    private func saveChanges() {
        place.name = placeName
        place.seasons = selectedSeasons.map { $0.rawValue }
        place.months = Array(selectedMonths)
        place.memo = memo

        place.imageData = selectedUIImage?.jpegData(compressionQuality: 0.8)

        onSave()
        dismiss()
    }

    private func deletePlace() {
        modelContext.delete(place)
        do {
            try modelContext.save()
            print("DEBUG: Place deleted")
        } catch {
            print("ERROR: Failed to delete Place → \(error)")
        }
        dismiss()
    }

    // タイトル行を共通化
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
                    .padding(.leading, 28) // ← アイコンの分だけ揃える
            }
        }
    }
}
