//
//  SeasonMonthPickerViewWrapper.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct SeasonMonthPickerViewWrapper: View {
    @Binding var selectedSeasons: Set<Season>
    @Binding var selectedMonths: Set<String>

    var body: some View {
        SeasonMonthPickerView(
            selectedSeasons: $selectedSeasons,
            selectedMonths: $selectedMonths
        )
    }
}
