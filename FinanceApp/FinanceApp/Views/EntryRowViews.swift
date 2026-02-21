//
//  EntryRowViews.swift
//  Finance App
//
//  Created by Князь on 05.05.2025.
//

import SwiftUI

struct EntryRowView: View {
    let entry: Entry
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(entry.category)
                Text(entry.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(entry.amount, format: .currency(code: AppFormat.currencyCode))
                .foregroundColor(entry.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}
