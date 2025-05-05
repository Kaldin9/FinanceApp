//
//  SettingsView.swift
//  Finance App
//
//
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var entryStore: EntryStore
    @State private var showExport = false
    @State private var exportURL: URL? = nil

    var body: some View {
        NavigationView {
            Form {
                Toggle("Тёмная тема", isOn: $isDarkMode)
                Button("Экспортировать данные") {
                    exportURL = entryStore.exportJSON()
                    showExport = true
                }
            }
            .navigationTitle("Настройки")
            .sheet(isPresented: $showExport) {
                if let url = exportURL { ActivityView(activityItems: [url]) }
            }
        }
    }
}
