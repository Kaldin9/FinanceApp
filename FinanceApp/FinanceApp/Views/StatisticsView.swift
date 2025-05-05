//
//  StatisticsView.swift
//  Finance App
//
//
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var store: EntryStore

    var body: some View {
        NavigationView {
            Chart {
                ForEach(store.entries) { entry in
                    BarMark(
                        x: .value("Дата", entry.date, unit: .day),
                        y: .value("Сумма", entry.amount)
                    )
                    .foregroundStyle(entry.type == .income ? .green : .red)
                }
            }
            .padding()
            .navigationTitle("Статистика")
        }
    }
}
