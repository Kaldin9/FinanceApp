//
//  ThemedScreen.swift
//  FinanceApp
//
//  Created by Князь on 09.05.2025.
//

import SwiftUI

/// Обёртка, которая подтягивает тему на весь экран
struct ThemedScreen<Content: View>: View {
    @Environment(\.colorScheme) private var cs
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            // общий фон
            (cs == .dark ? Color.black : Color(.systemBackground))
                .ignoresSafeArea()

            // внутри — ваш UI, с фоновыми формами и градиентами
            content
                .background(cs == .dark
                    ? Theme.formBackgroundDark
                    : Theme.formBackgroundLight
                )
                .foregroundStyle(cs == .dark
                    ? Theme.neonGradient
                    : Theme.skyGradient
                )
        }
    }
}
