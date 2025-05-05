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

    func spent(_ cat: String) -> Double {
        entryStore.entries.filter { $0.category == cat && $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(budgetStore.budgets) { b in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(b.category)
                            Text("Лимит: \(b.limit, format: .currency(code: Locale.current.currencyCode ?? "USD"))")
                                .font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        let s = spent(b.category)
                        Text("\(s, format: .currency(code: Locale.current.currencyCode ?? "USD"))")
                            .foregroundColor(s > b.limit ? .red : .green)
                    }
                    .contentShape(Rectangle()).onTapGesture { editBudget = b }
                }.onDelete(perform: budgetStore.delete)
            }
            .navigationTitle("Бюджеты")
            .toolbar { Button { showAdd = true } label: { Image(systemName: "plus.circle") } }
            .sheet(item: $editBudget) { AddBudgetView(budgetToEdit: $0) }
            .sheet(isPresented: $showAdd) { AddBudgetView() }
        }
    }
}
