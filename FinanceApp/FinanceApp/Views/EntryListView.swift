//
//  EntryListView.swift
//  Finance App
//
//
//

import SwiftUI

struct EntryListView: View {
    @EnvironmentObject var store: EntryStore
    @State private var showAdd = false
    @State private var editingEntry: Entry? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(store.displayedEntries) { entry in
                    EntryRowView(entry: entry)
                        .onTapGesture { editingEntry = entry }
                }
                .onDelete(perform: store.deleteDisplayed)
            }
            .searchable(text: $store.searchText, prompt: "Поиск по категории")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Тип", selection: $store.filterType) {
                            Text("Все").tag(EntryType?.none)
                            ForEach(EntryType.allCases) { type in Text(type.rawValue).tag(EntryType?.some(type)) }
                        }
                        Toggle("Сортировка по сумме", isOn: $store.sortAscending)
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAdd.toggle() } label: { Image(systemName: "plus") }
                }
            }
            .sheet(item: $editingEntry) { AddEntryView(entryToEdit: $0) }
            .sheet(isPresented: $showAdd) { AddEntryView() }
            .navigationTitle("Доходы и расходы")
        }
    }
}
