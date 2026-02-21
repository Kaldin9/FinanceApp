//
//  BudgetView.swift
//  Finance App
//
//
//

import SwiftUI

struct BudgetsView: View {
    @EnvironmentObject var budgetStore: BudgetStore
    @EnvironmentObject var entryStore: EntryStore
    @State private var showAdd = false
    @State private var editBudget: Budget? = nil
    @State private var period: BudgetPeriod = .monthly

    enum BudgetPeriod: String, CaseIterable, Identifiable {
        case weekly = "Неделя"
        case monthly = "Месяц"

        var id: String { rawValue }
        var component: Calendar.Component { self == .weekly ? .weekOfYear : .month }
        var title: String { self == .weekly ? "за неделю" : "за месяц" }
    }

    func spent(_ cat: String) -> Double {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: period.component, for: Date())

        return entryStore.entries
            .filter { $0.category == cat && $0.type == .expense }
            .filter { entry in
                guard let interval else { return true }
                return interval.contains(entry.date)
            }
            .reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("Период", selection: $period) {
                        ForEach(BudgetPeriod.allCases) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    ForEach(budgetStore.budgets) { b in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(b.category)
                                Text("Лимит \(period.title): \(b.limit, format: .currency(code: AppFormat.currencyCode))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            let s = spent(b.category)
                            Text("\(s, format: .currency(code: AppFormat.currencyCode))")
                                .foregroundColor(s > b.limit ? .red : .green)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { editBudget = b }
                    }
                    .onDelete(perform: budgetStore.delete)
                }
            }
            .navigationTitle("Бюджеты")
            .toolbar { Button { showAdd = true } label: { Image(systemName: "plus.circle") } }
            .sheet(item: $editBudget) { AddBudgetView(budgetToEdit: $0) }
            .sheet(isPresented: $showAdd) { AddBudgetView() }
        }
    }
}
