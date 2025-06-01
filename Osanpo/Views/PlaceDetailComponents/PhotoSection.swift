//
//  PhotoSection.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct PhotoSection: View {
    let image: UIImage
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("写真", systemImage: "photo")
                .foregroundColor(Color(hex: "3B4252"))
                .font(.headline)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
        }
    }
}
