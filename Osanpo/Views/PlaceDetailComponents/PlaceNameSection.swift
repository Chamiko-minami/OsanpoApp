//
//  PlaceNameSection.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct PlaceNameSection: View {
    let name: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(Color(hex: "3B4252"))
            Text(name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "3B4252"))
        }
    }
}
