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
    @FocusState private var isMemoFocused: Bool

    var onSave: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Image("sky_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 350)
                    .overlay(
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                Spacer().frame(height: 80)

                                // 行きたい場所
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "mappin.and.ellipse")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("行きたい場所")
                                            .foregroundColor(Color(hex: "3B4252"))
                                            .font(.system(.headline, design: .rounded).weight(.bold))
                                    }
                                    TextField("例：井の頭公園", text: $placeName)
                                        .font(.system(.body, design: .rounded).weight(.bold))
                                        .foregroundColor(Color(hex: "676666"))
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }

                                // いつ行きたい？
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("いつ行きたい？")
                                            .foregroundColor(Color(hex: "3B4252"))
                                            .font(.system(.headline, design: .rounded).weight(.bold))
                                        Text("行きたい季節・月を選択")
                                            .font(.system(.footnote, design: .rounded))
                                            .foregroundColor(.gray)
                                    }
                                    SeasonMonthPickerViewWrapper(
                                        selectedSeasons: $selectedSeasons,
                                        selectedMonths: $selectedMonths
                                    )
                                }

                                // メモ
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("メモ")
                                            .foregroundColor(Color(hex: "3B4252"))
                                            .font(.system(.headline, design: .rounded).weight(.bold))
                                    }
                                    ZStack(alignment: .topLeading) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .frame(minHeight: 66)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                            )
                                        TextEditor(text: $memo)
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(Color(hex: "676666"))
                                            .padding(8)
                                            .focused($isMemoFocused)
                                        if memo.isEmpty {
                                            Text("メモを入力")
                                                .foregroundColor(Color(.placeholderText))
                                                .font(.system(.body, design: .rounded))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                        }
                                    }
                                }

                                // 写真
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "photo")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("写真")
                                            .foregroundColor(Color(hex: "3B4252"))
                                            .font(.system(.headline, design: .rounded).weight(.bold))
                                    }
                                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                        HStack {
                                            Text("写真を選択")
                                                .font(.system(.body, design: .rounded).weight(.bold))
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

                                    if let uiImage = selectedUIImage ?? (place.imageData.flatMap { UIImage(data: $0) }) {
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 150)
                                                .cornerRadius(12)

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
                            .padding(.horizontal, 16)
                            .padding(.bottom, 80)
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
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

                ToolbarItemGroup(placement: .keyboard) {
                    if isMemoFocused {
                        Spacer()
                        Button("完了") { isMemoFocused = false }
                    }
                }
            }
            .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
        try? modelContext.save()
        onSave()
        dismiss()
    }
}
