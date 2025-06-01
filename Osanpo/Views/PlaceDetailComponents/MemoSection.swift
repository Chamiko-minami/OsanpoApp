//
//  MemoSection.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI

struct MemoSection: View {
    let memo: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("メモ", systemImage: "pencil")
                .foregroundColor(Color(hex: "3B4252"))
                .font(.headline)
            Text(memo)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
        }
    }
}
