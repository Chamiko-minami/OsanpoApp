import SwiftUI

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var place: Place

    private let monthOrder = ["1月", "2月", "3月", "4月", "5月", "6月",
                              "7月", "8月", "9月", "10月", "11月", "12月"]

    var body: some View {
        ZStack {
            backgroundView

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    placeNameSection()

                    // 🌷🌻🍁⛄️ ＋ 📅 月 表示セクション
                    seasonMonthSection()

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 92)
                .padding(.bottom, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)  // 黒い < を消す
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

    // MARK: – 背景
    private var backgroundView: some View {
        AnyView(
            Image("sky_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }

    // MARK: – 場所名セクション
    private func placeNameSection() -> some View {
        HStack(spacing: 6) {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(Color(hex: "3B4252"))
            Text(place.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "3B4252"))

            Spacer() // 左寄せ
        }
    }

    // MARK: – 行きたい季節・月セクション
    private func seasonMonthSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 🗓️ 見出し
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundColor(Color(hex: "3B4252"))
                Text("いつ行きたい？")
                    .font(.headline)
                    .foregroundColor(Color(hex: "3B4252"))
            }

            // 行きたい季節（文字だけ表示）
            Text("季節: " + place.seasons.map { $0.rawValue }.joined(separator: ", "))
                .font(.body)
                .foregroundColor(Color(hex: "3B4252"))

            // 行きたい月（文字だけ表示）
            Text("月: " + place.months.joined(separator: ", "))
                .font(.body)
                .foregroundColor(Color(hex: "3B4252"))
        }
    }

    // MARK: – 補助関数
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
