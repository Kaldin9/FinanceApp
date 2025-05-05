//
//  ReportsView.swift
//  Finance App
//
//
//

import SwiftUI
import Charts

struct ReportsView: View {
    @EnvironmentObject var store: EntryStore
    @State private var period: Period = .monthly

    enum Period: String, CaseIterable, Identifiable {
        case weekly = "Неделя"
        case monthly = "Месяц"
        var id: String { rawValue }
        var component: Calendar.Component { self == .weekly ? .weekOfYear : .month }
    }

    // Правильно объявляем Aggregate
    struct Aggregate: Identifiable {
        let id: UUID = UUID()
        let periodStart: Date
        let income: Double
        let expense: Double
    }

    // Формируем данные для графика
    var data: [Aggregate] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: store.entries) {
            cal.dateInterval(of: period.component, for: $0.date)?.start ?? $0.date
        }
        return grouped.map { start, items in
            let inc = items.filter { $0.type == .income }
                           .reduce(0) { $0 + $1.amount }
            let exp = items.filter { $0.type == .expense }
                           .reduce(0) { $0 + $1.amount }
            return Aggregate(periodStart: start, income: inc, expense: exp)
        }
        .sorted { $0.periodStart < $1.periodStart }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Период", selection: $period) {
                    ForEach(Period.allCases) { p in
                        Text(p.rawValue).tag(p)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Chart {
                    ForEach(data) { item in
                        BarMark(
                            x: .value("Дата", item.periodStart, unit: period.component),
                            y: .value("Доход", item.income)
                        )
                        .foregroundStyle(.green)

                        BarMark(
                            x: .value("Дата", item.periodStart, unit: period.component),
                            y: .value("Расход", item.expense)
                        )
                        .foregroundStyle(.red)
                    }
                }
                .chartLegend(position: .bottom)
                .padding()
            }
            .navigationTitle("Статистика")
        }
    }
}
