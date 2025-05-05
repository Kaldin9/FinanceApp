//
//  AddBudgetView.swift
//  Finance App
//
//
//

import SwiftUI

struct AddBudgetView: View {
    @EnvironmentObject var store: BudgetStore
    @Environment(\.dismiss) private var dismiss

    @State private var category = ""
    @State private var limitText = ""
    var budgetToEdit: Budget? = nil

    var body: some View {
        NavigationView {
            Form {
                TextField("Категория", text: $category)
                TextField("Лимит", text: $limitText).keyboardType(.decimalPad)
            }
            .onAppear { if let b = budgetToEdit { category = b.category; limitText = String(b.limit) } }
            .navigationTitle(budgetToEdit == nil ? "Новый бюджет" : "Редактировать бюджет")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(budgetToEdit == nil ? "Добавить" : "Сохранить") {
                        guard let lim = Double(limitText) else { return }
                        let b = Budget(id: budgetToEdit?.id ?? UUID(), category: category, limit: lim)
                        budgetToEdit == nil ? store.add(b) : store.update(b)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) { Button("Отмена") { dismiss() } }
            }
        }
    }
}
