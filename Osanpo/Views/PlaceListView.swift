//
//  PlaceListView.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/05/31.
//

import SwiftUI

struct PlaceListView: View {
    @State private var savedPlaces: [Place] = []
    @State private var currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1

    private let months = ["1月", "2月", "3月", "4月", "5月", "6月",
                          "7月", "8月", "9月", "10月", "11月", "12月"]

    var body: some View {
        NavigationStack {
            VStack {
                // 月の切り替えUI
                HStack {
                    Button(action: {
                        currentMonthIndex = (currentMonthIndex - 1 + 12) % 12
                    }) {
                        Image(systemName: "chevron.left")
                            .padding(.horizontal)
                    }

                    Text(months[currentMonthIndex])
                        .font(.title2)
                        .fontWeight(.bold)

                    Button(action: {
                        currentMonthIndex = (currentMonthIndex + 1) % 12
                    }) {
                        Image(systemName: "chevron.right")
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 100)

                // リスト表示
                let month = months[currentMonthIndex]
                let hasPlacesThisMonth = savedPlaces.contains { $0.months.contains(month) }

                if !hasPlacesThisMonth {
                    Text("まだ行きたい場所が登録されていません")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach($savedPlaces, id: \.id) { $place in
                            if place.months.contains(month) {
                                NavigationLink(destination: PlaceDetailView(place: $place)) {
                                    VStack(alignment: .leading) {
                                        Text(place.name)
                                            .font(.headline)
                                        Text(place.months.sorted().joined(separator: ", "))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }

                Spacer()

                NavigationLink(destination: PlaceAddView()) {
                    Text("+ 新規追加")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("行きたい場所リスト")
            .onAppear {
                if let data = UserDefaults.standard.data(forKey: "savedPlaces") {
                    do {
                        let decoded = try JSONDecoder().decode([Place].self, from: data)
                        savedPlaces = decoded
                    } catch {
                        print("デコード失敗: \(error)")
                    }
                }
            }
        }
    }
}
