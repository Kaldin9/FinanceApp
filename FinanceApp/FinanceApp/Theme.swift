//
//  Theme.swift
//  FinanceApp
//
//  Created by Князь on 08.05.2025.
//

import SwiftUI

/// Общие цвета и градиенты для приложения
enum Theme {
    /// Неоновый градиент для тёмного режима
    static let neonGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "00E5FF"),
            Color(hex: "7551FF")
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Градиент Sky→Navy для светлого режима
    static let skyGradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "89CFF0"),
            Color(hex: "034F84")
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Фон для форм и списков
    static let formBackgroundDark: Color  = Color.white.opacity(0.05)
    static let formBackgroundLight: Color = Color(.systemGray5)
}


extension Color {
    /// Инициализатор из HEX-строки: "FF0000" или "#FF0000"
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        let scanner = Scanner(string: hexString)
        var hexVal: UInt64 = 0
        if scanner.scanHexInt64(&hexVal) {
            let r = Double((hexVal >> 16) & 0xFF) / 255
            let g = Double((hexVal >>  8) & 0xFF) / 255
            let b = Double( hexVal        & 0xFF) / 255
            self.init(red: r, green: g, blue: b)
        } else {
            self = .clear
        }
    }
}
