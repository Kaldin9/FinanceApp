//
//  Entry.swift
//  Finance App
//
// 
//

import Foundation

struct Entry: Identifiable, Codable {
    let id: UUID                   // Уникальный идентификатор записи
    var amount: Double             // Сумма дохода/расхода
    var category: String           // Категория (например, "Еда", "Зарплата")
    var type: EntryType            // Доход или расход
    var date: Date                 // Дата записи

    init(id: UUID = UUID(), amount: Double, category: String, type: EntryType, date: Date) {
        self.id = id
        self.amount = amount
        self.category = category
        self.type = type
        self.date = date
    }
}

enum EntryType: String, CaseIterable, Codable, Identifiable {
    case income = "Доход"
    case expense = "Расход"
    var id: String { rawValue }
}
