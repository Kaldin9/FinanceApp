//
//  EntryStore.swift
//  Finance App
//
//
//

import Foundation
import Combine

@MainActor
class EntryStore: ObservableObject {
    @Published private(set) var entries: [Entry] = [] {
        didSet {
            guard !isHydrating else { return }
            scheduleSave()
        }
    }
    private let saveURL = FileManager.documentsDirectory.appendingPathComponent("entries.json")
    private let saveQueue = DispatchQueue(label: "EntryStore.SaveQueue", qos: .utility)
    private var saveWorkItem: DispatchWorkItem?
    private var isHydrating = false
    @Published private(set) var lastLoadError: String?

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
    func deleteDisplayed(at offsets: IndexSet) {
        let idsToDelete = offsets.compactMap { index in
            displayedEntries.indices.contains(index) ? displayedEntries[index].id : nil
        }
        entries.removeAll { idsToDelete.contains($0.id) }
    }

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
            try data.write(to: exportURL, options: .atomic)
            return exportURL
        } catch {
            print("Export error: \(error)")
            return nil
        }
    }

    private func scheduleSave() {
        let snapshot = entries
        saveWorkItem?.cancel()
        let workItem = DispatchWorkItem { [saveURL] in
            do {
                let data = try JSONEncoder().encode(snapshot)
                try data.write(to: saveURL, options: .atomic)
            } catch {
                print("Error saving entries: \(error)")
            }
        }
        saveWorkItem = workItem
        saveQueue.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }

    private func load() {
        isHydrating = true
        defer { isHydrating = false }

        guard FileManager.default.fileExists(atPath: saveURL.path) else {
            entries = []
            return
        }

        do {
            let data = try Data(contentsOf: saveURL)
            entries = try JSONDecoder().decode([Entry].self, from: data)
            lastLoadError = nil
        } catch {
            backupCorruptedStore()
            entries = []
            lastLoadError = "Повреждён файл данных записей. Создана резервная копия."
            print("Error loading entries: \(error)")
        }
    }

    private func backupCorruptedStore() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let stamp = formatter.string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let backupURL = FileManager.documentsDirectory.appendingPathComponent("entries_corrupted_\(stamp).json")
        do {
            if FileManager.default.fileExists(atPath: backupURL.path) {
                try FileManager.default.removeItem(at: backupURL)
            }
            try FileManager.default.moveItem(at: saveURL, to: backupURL)
        } catch {
            print("Error backing up corrupted entries store: \(error)")
        }
    }
}
