//
//  Budget.swift
//  Finance App
//
//
//

import Foundation

struct Budget: Identifiable, Codable {
    let id: UUID                  // Уникальный идентификатор бюджета
    var category: String          // Категория, для которой задаётся лимит
    var limit: Double             // Лимит суммы за период (например, в месяц)

    init(id: UUID = UUID(), category: String, limit: Double) {
        self.id = id
        self.category = category
        self.limit = limit
    }
}
