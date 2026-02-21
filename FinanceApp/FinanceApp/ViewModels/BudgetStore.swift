//
//  BudgetStore.swift
//  Finance App
//
//
//

import Foundation
import Combine

@MainActor
class BudgetStore: ObservableObject {
    @Published var budgets: [Budget] = [] {
        didSet {
            guard !isHydrating else { return }
            scheduleSave()
        }
    }
    private let saveURL = FileManager.documentsDirectory.appendingPathComponent("budgets.json")
    private let saveQueue = DispatchQueue(label: "BudgetStore.SaveQueue", qos: .utility)
    private var saveWorkItem: DispatchWorkItem?
    private var isHydrating = false
    @Published private(set) var lastLoadError: String?

    init() { load() }

    func add(_ budget: Budget) { budgets.append(budget) }
    func update(_ budget: Budget) {
        if let idx = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[idx] = budget
        }
    }
    func delete(at offsets: IndexSet) { budgets.remove(atOffsets: offsets) }

    private func scheduleSave() {
        let snapshot = budgets
        saveWorkItem?.cancel()
        let workItem = DispatchWorkItem { [saveURL] in
            do {
                let data = try JSONEncoder().encode(snapshot)
                try data.write(to: saveURL, options: .atomic)
            } catch {
                print("Error saving budgets: \(error)")
            }
        }
        saveWorkItem = workItem
        saveQueue.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }

    private func load() {
        isHydrating = true
        defer { isHydrating = false }

        guard FileManager.default.fileExists(atPath: saveURL.path) else {
            budgets = []
            return
        }

        do {
            let data = try Data(contentsOf: saveURL)
            budgets = try JSONDecoder().decode([Budget].self, from: data)
            lastLoadError = nil
        } catch {
            backupCorruptedStore()
            budgets = []
            lastLoadError = "Повреждён файл данных бюджетов. Создана резервная копия."
            print("Error loading budgets: \(error)")
        }
    }

    private func backupCorruptedStore() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let stamp = formatter.string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let backupURL = FileManager.documentsDirectory.appendingPathComponent("budgets_corrupted_\(stamp).json")
        do {
            if FileManager.default.fileExists(atPath: backupURL.path) {
                try FileManager.default.removeItem(at: backupURL)
            }
            try FileManager.default.moveItem(at: saveURL, to: backupURL)
        } catch {
            print("Error backing up corrupted budgets store: \(error)")
        }
    }
}
