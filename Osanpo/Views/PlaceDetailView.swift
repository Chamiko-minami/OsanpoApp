import SwiftUI

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var place: Place

    private let yellowHeaderHeight: CGFloat = 60  // 黄色背景の高さ

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 100) // 全体を少し下げる

                    // 行きたい場所名
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color(hex: "3B4252").opacity(0.8))
                        Text(place.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "3B4252").opacity(0.8))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 5)

                    // ZStack: 白背景 → 黄色背景 → 🗓️ テキスト
                    ZStack(alignment: .topLeading) {
                        // 白背景
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 340, height: 180)
                            .padding(.top, yellowHeaderHeight / 2) // 黄色背景と半分被せる

                        VStack(alignment: .leading, spacing: 16) {
                            // 黄色背景 + 🗓️ テキスト
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(hex: "3B4252").opacity(0.8))
                                Text("いつ行きたい！")
                                    .font(.headline)
                                    .foregroundColor(Color(hex: "3B4252").opacity(0.8))
                            }
                            .padding(.horizontal, 12)
                            .frame(height: yellowHeaderHeight)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "FFF4B3").opacity(0.5))
                            )
                            // ★ 左端は白背景と揃える → padding(.leading, 24)
                            .padding(.leading, 24)
                            .padding(.top, 0)

                            // 季節アイコン
                            HStack(spacing: 12) {
                                ForEach(["春", "夏", "秋", "冬"], id: \.self) { season in
                                    let info = seasonColorInfo(for: season)
                                    let isSelected = place.seasons.map { $0.rawValue }.contains(season)

                                    Image(info.assetName)
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .padding(6)
                                        .background(Color(hex: info.backgroundColor).opacity(isSelected ? 1.0 : 0.3))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isSelected ? Color(hex: info.borderColor) : .clear, lineWidth: isSelected ? 1 : 0)
                                        )
                                        .opacity(isSelected ? 1.0 : 0.3)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                            // 月アイコン → 横スクロール
                            let monthOrder = ["1月", "2月", "3月", "4月", "5月", "6月",
                                              "7月", "8月", "9月", "10月", "11月", "12月"]

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(monthOrder, id: \.self) { month in
                                        let season = seasonForMonth(month)
                                        let isSelected = place.months.contains(month)

                                        Text(month)
                                            .font(.footnote)
                                            .foregroundColor(Color(hex: "676666").opacity(isSelected ? 1.0 : 0.3))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(hex: season.backgroundColor)
                                                            .opacity(isSelected ? 1.0 : 0.3))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(isSelected ? Color(hex: season.borderColor) : .clear,
                                                                    lineWidth: isSelected ? 0.5 : 0)
                                                    )
                                            )
                                    }
                                }
                                .padding(.horizontal, 24)
                            }

                            Spacer(minLength: 16)
                        }
                        .padding(.bottom, 24)
                    }
                    // ★ 白背景の ZStack 全体 → .padding(.horizontal, 24) で白背景の左端と黄色背景の左端が揃う
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(Color(hex: "FFF4B3").opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                // 左：戻るボタン
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

                // 中央：タイトル
                ToolbarItem(placement: .principal) {
                    Text("行きたい場所")
                        .foregroundColor(Color(hex: "7C8894"))
                        .font(.headline)
                }

                // 右：編集ボタン
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: PlaceAddView()) {
                        Text("編集")
                            .foregroundColor(Color(hex: "7C8894"))
                            .font(.body)
                    }
                }
            }
        }
    }

    // MARK: - 背景
    private var backgroundView: some View {
        Image("sky_background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    // MARK: - 補助関数
    private func seasonColorInfo(for season: String)
        -> (backgroundColor: String, borderColor: String, assetName: String)
    {
        switch season {
        case "春": return ("FFD1DC", "EB8FA9", "haru_icon")
        case "夏": return ("FFF4B3", "F1C93B", "natsu_icon")
        case "秋": return ("FFC8A2", "E38B4D", "aki_icon")
        case "冬": return ("A6D8E4", "6BAACD", "fuyu_icon")
        default:   return ("CCCCCC", "999999", "")
        }
    }

    private func seasonForMonth(_ month: String)
        -> (backgroundColor: String, borderColor: String)
    {
        switch month {
        case "3月", "4月", "5月":   return ("FFD1DC", "EB8FA9")
        case "6月", "7月", "8月":   return ("FFF4B3", "F1C93B")
        case "9月", "10月", "11月": return ("FFC8A2", "E38B4D")
        case "12月", "1月", "2月":  return ("A6D8E4", "6BAACD")
        default:                    return ("CCCCCC", "999999")
        }
    }
}
