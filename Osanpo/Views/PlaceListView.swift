//
//  PlaceListView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/31.
//

import SwiftUI
import SwiftData

struct PlaceListView: View {
    @Query var places: [Place]
    @State private var currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    
    private let months = ["1月", "2月", "3月", "4月", "5月", "6月",
                          "7月", "8月", "9月", "10月", "11月", "12月"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景画像
                Image("sky_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // 🌙 月の選択UI
                    HStack(spacing: 16) {
                        Button(action: {
                            currentMonthIndex = (currentMonthIndex - 1 + 12) % 12
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 28, weight: .medium))
                        }
                        
                        Text(months[currentMonthIndex])
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                        
                        Button(action: {
                            currentMonthIndex = (currentMonthIndex + 1) % 12
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 28, weight: .medium))
                        }
                    }
                    .foregroundColor(Color(hex: "7C8894"))
                    .padding(.top, 84)
                    .padding(.vertical, 10)
                    
                    // 📍 行きたい場所リスト
                    let month = months[currentMonthIndex]
                    let filteredPlaces = places.filter { $0.months.contains(month) }
                    
                    if filteredPlaces.isEmpty {
                        Spacer().frame(height: 16)
                        
                        Text("まだ行きたい場所が登録されていません")
                            .foregroundColor(.gray)
                            .font(.body)
                            .padding(.top, 40)
                        
                        Spacer() // 空のときだけ Spacer を入れて画面下を埋める
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(filteredPlaces) { place in
                                    NavigationLink(destination: PlaceDetailView(place: place)) {
                                        HStack {
                                            Image(systemName: "mappin.and.ellipse")
                                                .foregroundColor(Color(hex: "3B4252").opacity(0.75))
                                            Text(place.name)
                                                .foregroundColor(Color(hex: "3B4252").opacity(0.75))
                                                .font(.headline)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(Color(hex: "3B4252").opacity(0.75))
                                        }
                                        .padding()
                                        .background(Color.white.opacity(0.7))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 16)
                                    }
                                }
                                .padding(.top, 4)
                            }
                            .padding(.bottom, 20) // 少し余白
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline) // ナビバー高さ短く保つ✨
                .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbar {
                    // ナビゲーションバー中央タイトル
                    ToolbarItem(placement: .principal) {
                        Text("行きたい場所")
                            .font(.headline)
                            .foregroundColor(Color(hex: "7C8894")) // ← 塗り100%
                    }
                    
                    // ナビゲーションバー右側「追加」ボタン
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: PlaceAddView()) {
                            Text("追加")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "7C8894"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
}
