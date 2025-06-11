//
//  PlaceListView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/31.
//

import SwiftUI
import SwiftData

struct PlaceListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var places: [Place]
    @State private var currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    @State private var isPresentingAddView = false
    @State private var forceReload = false

    private let months = ["1月", "2月", "3月", "4月", "5月", "6月",
                          "7月", "8月", "9月", "10月", "11月", "12月"]

    var body: some View {
        NavigationStack {
            ZStack {
                Image("sky_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // 🌙 月の選択UI
                    HStack(spacing: 16) {
                        Button(action: {
                            currentMonthIndex = (currentMonthIndex - 1 + 12) % 12
                            forceReload.toggle()
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
                            forceReload.toggle()
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 28, weight: .medium))
                        }
                    }
                    .foregroundColor(Color(hex: "7C8894"))
                    .padding(.top, 84)
                    .padding(.vertical, 10)

                    // 📍 行きたい場所リスト（現在の月で絞り込み）
                    let selectedMonth = months[currentMonthIndex]
                    let filteredPlaces = places.filter { place in
                        place.months.contains(selectedMonth)
                    }

                    Group {
                        if filteredPlaces.isEmpty {
                            Spacer().frame(height: 16)

                            Text("まだ行きたい場所が登録されていません")
                                .foregroundColor(.gray)
                                .font(.body)
                                .padding(.top, 40)

                            Spacer()
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
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    .id(forceReload)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("行きたい場所リスト")
                            .font(.headline)
                            .foregroundColor(Color(hex: "7C8894"))
                    }
                }
                .onAppear {
                    print("DEBUG: All places → currentMonth = \(months[currentMonthIndex])")
                    for place in places {
                        print("  name: \(place.name), months: \(place.months.map { "(\($0))" }), seasons: \(place.seasons)")
                        for m in place.months {
                            print("    '\(m)' (len=\(m.count))")
                        }
                    }
                }

                // ⭐️ 右下に「＋」ボタン
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresentingAddView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color(hex: "7C8894"))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.bottom, 90)
                        .padding(.trailing, 24)
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingAddView) {
            PlaceAddView()
                .modelContext(modelContext)
                .onDisappear {
                    forceReload.toggle()
                }
        }
    }
}
