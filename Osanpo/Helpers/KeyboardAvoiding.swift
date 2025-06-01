//
//  KeyboardAvoiding.swift
//  Osanpo
//
//  Created by 酒井みな実 on 2025/06/01.
//

import SwiftUI
import Combine

extension View {
    func keyboardAvoiding() -> some View {
        self.modifier(KeyboardAvoidingModifier())
    }
}

struct KeyboardAvoidingModifier: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onReceive(Publishers.keyboardHeight) { height in
                withAnimation(.easeOut(duration: 0.25)) {
                    self.offset = height
                }
            }
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow: AnyPublisher<CGFloat, Never> = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .eraseToAnyPublisher()

        let willHide: AnyPublisher<CGFloat, Never> = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .eraseToAnyPublisher()

        return MergeMany([willShow, willHide])
            .eraseToAnyPublisher()
    }
}
