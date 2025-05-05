//
//  EntryStore.swift
//  Finance App
//
//
//

import Foundation
import Combine

class EntryStore: ObservableObject {
    @Published private(set) var entries: [Entry] = [] {
        didSet { save() }
    }
    private let saveURL = FileManager.documentsDirectory.appendingPathComponent("entries.json")

    // Поисковые и фильтрующие параметры
    @Published var searchText: String = ""
    @Published var filterType: EntryType? = nil
    @Published var sortAscending: Bool = false

    init() { load() }

    func add(_ entry: Entry) { entries.append(entry) }
    func update(_ entry: Entry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
        }
    }
    func delete(at offsets: IndexSet) { entries.remove(atOffsets: offsets) }

    // Отфильтрованный и отсортированный список
    var displayedEntries: [Entry] {
        entries
            .filter { filterType == nil || $0.type == filterType }
            .filter { searchText.isEmpty || $0.category.localizedCaseInsensitiveContains(searchText) }
            .sorted { sortAscending ? $0.amount < $1.amount : $0.date > $1.date }
    }

    // Экспорт в JSON
    func exportJSON() -> URL? {
        let exportURL = FileManager.documentsDirectory.appendingPathComponent("export_entries.json")
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: exportURL)
            return exportURL
        } catch {
            print("Export error: \(error)")
            return nil
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: saveURL)
        } catch { print("Error saving entries: \(error)") }
    }
    private func load() {
        do {
            let data = try Data(contentsOf: saveURL)
            entries = try JSONDecoder().decode([Entry].self, from: data)
        } catch { entries = [] }
    }
}
