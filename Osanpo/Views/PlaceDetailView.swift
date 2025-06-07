import SwiftUI

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var place: Place

    private let yellowHeaderHeight: CGFloat = 44

    var body: some View {
        ZStack {
            backgroundView

            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 80) // ← 全体を下に

                // 行きたい場所名
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color(hex: "3B4252"))
                    Text(place.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "3B4252"))
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                // 🟡 黄色背景は 白背景の外！ & 黄色背景の中心 = 白背景上端
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .foregroundColor(Color(hex: "3B4252"))
                    Text("いつ行きたい！") // ← びっくりマーク！
                        .font(.headline)
                        .foregroundColor(Color(hex: "3B4252"))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color(hex: "FFF4B3").opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.leading, 24)
                .offset(y: yellowHeaderHeight / 2) // ← ここで黄色背景を少し下げる（半分だけかぶせる形になる！）

                // Spacer を黄色背景と白背景の関係に合わせる
                Spacer().frame(height: yellowHeaderHeight / 2)

                // 白背景 + 季節・月
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 340, height: 200)

                    VStack(alignment: .leading, spacing: 16) {
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
                                            .stroke(isSelected ? Color(hex: info.borderColor) : .clear, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                        // 月表示
                        Text("月: " + place.months.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "3B4252"))
                            .padding(.horizontal, 24)

                        Spacer(minLength: 16)
                    }
                    .padding(.bottom, 24)
                }
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
}
