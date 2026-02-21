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
    @State private var validationError: String?
    var budgetToEdit: Budget? = nil

    private var canSubmit: Bool {
        parsedLimit != nil && !normalizedCategory.isEmpty
    }

    private var normalizedCategory: String {
        category.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var parsedLimit: Double? {
        parseDecimal(limitText)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Категория", text: $category)
                TextField("Лимит", text: $limitText).keyboardType(.decimalPad)
            }
            .onAppear {
                if let b = budgetToEdit {
                    category = b.category
                    limitText = decimalFormatter.string(from: NSNumber(value: b.limit)) ?? String(b.limit)
                }
            }
            .navigationTitle(budgetToEdit == nil ? "Новый бюджет" : "Редактировать бюджет")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(budgetToEdit == nil ? "Добавить" : "Сохранить") {
                        guard let limit = parsedLimit, limit > 0 else {
                            validationError = "Введите корректный лимит больше 0."
                            return
                        }
                        guard !normalizedCategory.isEmpty else {
                            validationError = "Укажите категорию."
                            return
                        }
                        let b = Budget(id: budgetToEdit?.id ?? UUID(), category: normalizedCategory, limit: limit)
                        budgetToEdit == nil ? store.add(b) : store.update(b)
                        dismiss()
                    }
                    .disabled(!canSubmit)
                }
                ToolbarItem(placement: .cancellationAction) { Button("Отмена") { dismiss() } }
            }
        }
        .alert("Ошибка ввода", isPresented: isShowingValidationError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationError ?? "")
        }
    }

    private var isShowingValidationError: Binding<Bool> {
        Binding(
            get: { validationError != nil },
            set: { shouldShow in
                if !shouldShow { validationError = nil }
            }
        )
    }

    private var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        return formatter
    }

    private func parseDecimal(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        if let number = decimalFormatter.number(from: trimmed) {
            return number.doubleValue
        }
        return Double(trimmed.replacingOccurrences(of: ",", with: "."))
    }
}
