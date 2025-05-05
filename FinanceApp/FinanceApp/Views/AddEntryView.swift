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
    var entryToEdit: Entry? = nil

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
                    amountText = String(e.amount)
                    category = e.category
                    type = e.type
                    date = e.date
                }
            }
            .navigationTitle(entryToEdit == nil ? "Новая запись" : "Редактировать запись")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(entryToEdit == nil ? "Добавить" : "Сохранить") {
                        guard let amount = Double(amountText) else { return }
                        let entry = Entry(id: entryToEdit?.id ?? UUID(), amount: amount, category: category, type: type, date: date)
                        entryToEdit == nil ? store.add(entry) : store.update(entry)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) { Button("Отмена") { dismiss() } }
            }
        }
    }
}
