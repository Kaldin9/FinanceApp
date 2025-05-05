//
//  BudgetStore.swift
//  Finance App
//
//
//

import Foundation
import Combine

class BudgetStore: ObservableObject {
    @Published var budgets: [Budget] = [] {
        didSet { save() }
    }
    private let saveURL = FileManager.documentsDirectory.appendingPathComponent("budgets.json")

    init() { load() }

    func add(_ budget: Budget) { budgets.append(budget) }
    func update(_ budget: Budget) {
        if let idx = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[idx] = budget
        }
    }
    func delete(at offsets: IndexSet) { budgets.remove(atOffsets: offsets) }

    private func save() {
        do {
            let data = try JSONEncoder().encode(budgets)
            try data.write(to: saveURL)
        } catch { print("Error saving budgets: \(error)") }
    }
    private func load() {
        do {
            let data = try Data(contentsOf: saveURL)
            budgets = try JSONDecoder().decode([Budget].self, from: data)
        } catch { budgets = [] }
    }
}

