//
//  AddEntryView.swift
//  Finance App
//
//
//

import SwiftUI

struct AddEntryView: View {
    @EnvironmentObject var store: EntryStore
    @Environment(\.dismiss) private var dismiss

    @State private var amountText: String = ""
    @State private var category: String = ""
    @State private var type: EntryType = .expense
    @State private var date: Date = Date()
    @State private var validationError: String?
    var entryToEdit: Entry? = nil

    private var canSubmit: Bool {
        parsedAmount != nil && !normalizedCategory.isEmpty
    }

    private var normalizedCategory: String {
        category.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var parsedAmount: Double? {
        parseDecimal(amountText)
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Сумма & Категория") {
                    TextField("Сумма", text: $amountText)
                        .keyboardType(.decimalPad)
                    TextField("Категория", text: $category)
                }
                Section("Тип & Дата") {
                    Picker("Тип записи", selection: $type) {
                        ForEach(EntryType.allCases) { variant in Text(variant.rawValue).tag(variant) }
                    }
                    .pickerStyle(.segmented)
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                }
            }
            .onAppear {
                if let e = entryToEdit {
                    amountText = decimalFormatter.string(from: NSNumber(value: e.amount)) ?? String(e.amount)
                    category = e.category
                    type = e.type
                    date = e.date
                }
            }
            .navigationTitle(entryToEdit == nil ? "Новая запись" : "Редактировать запись")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(entryToEdit == nil ? "Добавить" : "Сохранить") {
                        guard let amount = parsedAmount, amount > 0 else {
                            validationError = "Введите корректную сумму больше 0."
                            return
                        }
                        guard !normalizedCategory.isEmpty else {
                            validationError = "Укажите категорию."
                            return
                        }
                        let entry = Entry(
                            id: entryToEdit?.id ?? UUID(),
                            amount: amount,
                            category: normalizedCategory,
                            type: type,
                            date: date
                        )
                        entryToEdit == nil ? store.add(entry) : store.update(entry)
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
