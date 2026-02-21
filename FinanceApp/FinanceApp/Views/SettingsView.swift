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
    @State private var showExportError = false

    var body: some View {
        NavigationView {
            Form {
                Toggle("Тёмная тема", isOn: $isDarkMode)
                Button("Экспортировать данные") {
                    if let url = entryStore.exportJSON() {
                        exportURL = url
                        showExport = true
                    } else {
                        showExportError = true
                    }
                }
            }
            .navigationTitle("Настройки")
            .sheet(isPresented: $showExport) {
                if let url = exportURL { ActivityView(activityItems: [url]) }
            }
            .alert("Ошибка экспорта", isPresented: $showExportError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Не удалось подготовить файл для экспорта.")
            }
        }
    }
}
