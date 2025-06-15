//
//  PlaceAddView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/31.
//

import SwiftUI
import SwiftData
import PhotosUI

struct PlaceAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // フォーカス管理
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isMemoFocused: Bool

    // 入力データ
    @State private var placeName: String = ""
    @State private var selectedSeasons: Set<Season> = []
    @State private var selectedMonths: Set<String> = []
    @State private var memo: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var showSaveAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景画像
                Image("sky_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // カード
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 350)
                    .overlay(
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                Spacer().frame(height: 80)

                                // MARK: 行きたい場所
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "mappin.and.ellipse")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("行きたい場所")
                                            .foregroundColor(Color(hex: "3B4252"))
                                            .font(.system(.headline, design: .rounded).weight(.bold))
                                    }
                                    .ignoresSafeArea(.keyboard, edges: .bottom)
                                    TextField("例：井の頭公園", text: $placeName)
                                        .font(.system(.body, design: .rounded).weight(.bold))
                                        .foregroundColor(Color(hex: "676666"))   // ← 入力文字色
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .focused($isTextFieldFocused)
                                }

                                // MARK: いつ行きたい？
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
                                        selectedMonths:  $selectedMonths
                                    )
                                }

                                // MARK: メモ
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(Color(hex: "3B4252"))
                                        Text("メモ")
                                            .foregroundColor(Color(hex: "3B4252"))
                                            .font(.system(.headline, design: .rounded).weight(.bold))
                                    }
                                    ZStack(alignment: .topLeading) {
                                        // 枠
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .frame(minHeight: 66)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                            )

                                        // 実際のエディタ
                                        TextEditor(text: $memo)
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(Color(hex: "676666"))  // ← 入力文字色
                                            .padding(8)
                                            .focused($isMemoFocused)

                                        // placeholder
                                        if memo.isEmpty {
                                            Text("メモを入力")
                                                .foregroundColor(Color(.placeholderText))
                                                .font(.system(.body, design: .rounded))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                        }
                                    }
                                }

                                // MARK: 写真
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
                                    .onChange(of: selectedPhotoItem) { _, item in
                                        if let item {
                                            Task {
                                                if let data = try? await item.loadTransferable(type: Data.self),
                                                   let uiImage = UIImage(data: data) {
                                                    selectedUIImage = uiImage
                                                }
                                            }
                                        }
                                    }
                                    if let image = selectedUIImage {
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 150)
                                                .cornerRadius(12)
                                            Button {
                                                selectedUIImage   = nil
                                                selectedPhotoItem = nil
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.gray.opacity(0.8))
                                                    .padding(8)
                                            }
                                        }
                                    }
                                }

                                Spacer(minLength: 20)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 80)
                        }
                        // キーボードで全体が持ち上がらないように
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    )
            }
            // ナビバー設定
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible,              for: .navigationBar)
            .toolbarColorScheme(.light,              for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color(hex: "7C8894"))
                            Text("リスト")
                                .foregroundColor(Color(hex: "7C8894"))
                                .font(.system(.body, design: .rounded).weight(.bold))
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("行きたい場所を登録")
                        .foregroundColor(Color(hex: "7C8894"))
                        .font(.system(.headline, design: .rounded).weight(.bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { savePlace() } label: {
                        Text("保存")
                            .foregroundColor(Color(hex: "7C8894"))
                            .font(.system(.body,   design: .rounded).weight(.bold))
                    }
                }
                // メモ入力用のDone ボタン
                ToolbarItemGroup(placement: .keyboard) {
                    if isMemoFocused {
                        Spacer()
                        Button("完了") { isMemoFocused = false }
                    }
                }
            }
            .alert("入力不足です", isPresented: $showSaveAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("行きたい場所、季節、月をすべて入力してください。")
            }
            .onAppear {
                let current = "\(Calendar.current.component(.month, from: Date()))月"
                if let season = Season.forMonth(current) {
                    selectedMonths  = [current]
                    selectedSeasons = [season]
                }
            }
        }
    }

    private func savePlace() {
        if placeName.isEmpty || selectedSeasons.isEmpty || selectedMonths.isEmpty {
            showSaveAlert = true
            return
        }
        let newPlace = Place(
            name:      placeName,
            seasons:   selectedSeasons.map(\.rawValue),
            months:    Array(selectedMonths),
            memo:      memo.isEmpty ? nil : memo,
            imageData: selectedUIImage?.jpegData(compressionQuality: 0.8)
        )
        modelContext.insert(newPlace)
        try? modelContext.save()
        dismiss()
    }
}
