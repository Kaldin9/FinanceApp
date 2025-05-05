//
//  Finance_AppApp.swift
//  Finance App
//
//  Created by Князь on 05.05.2025.
//

import SwiftUI

@main
struct Finance_AppApp: App {
    @StateObject private var entryStore = EntryStore()
    @StateObject private var budgetStore = BudgetStore()
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            TabView {
                EntryListView().tabItem { Label("Записи", systemImage: "list.bullet") }
                ReportsView().tabItem { Label("Статистика", systemImage: "chart.bar.fill") }
                BudgetsView().tabItem { Label("Бюджеты", systemImage: "tag.fill") }
                SettingsView().tabItem { Label("Настройки", systemImage: "gearshape.fill") }
            }
            .environmentObject(entryStore)
            .environmentObject(budgetStore)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
