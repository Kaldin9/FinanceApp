//
//  NightNeonChartView.swift
//  FinanceApp
//
// 
//

import SwiftUI

struct NightNeonChartView: View {
    // 1) Получаем записи и тему
    @EnvironmentObject private var store: EntryStore
    @Environment(\.colorScheme) private var colorScheme
    private var isDark: Bool { colorScheme == .dark }

    // 2) Модель для одного периода (месяц)
    struct PeriodData: Identifiable {
        let id = UUID()
        let periodStart: Date
        let net: Double

        /// “Май 25”, “Июн 25” и т. д.
        var label: String {
            let df = DateFormatter()
            df.dateFormat = "LLL yy"
            return df.string(from: periodStart)
        }
    }

    // 3) Собираем данные из EntryStore
    private var data: [PeriodData] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: store.entries) {
            cal.dateInterval(of: .month, for: $0.date)?.start ?? $0.date
        }
        return grouped.map { monthStart, entries in
            let income  = entries.filter { $0.type == .income  }.map(\.amount).reduce(0, +)
            let expense = entries.filter { $0.type == .expense }.map(\.amount).reduce(0, +)
            return PeriodData(periodStart: monthStart, net: income - expense)
        }
        .sorted { $0.periodStart < $1.periodStart }
    }

    // MARK: — градиент для положительных значений
    private var posGradient: LinearGradient {
        if isDark {
            // неоновый голубо-фиолетовый
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "00E5FF"), Color(hex: "7551FF")]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            // sky → navy
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "89CFF0"), Color(hex: "034F84")]),
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }

    // MARK: — Негативный градиент (расходы)
    private var negGradient: LinearGradient {
        if isDark {
            // тёмная тема: пурпурно-розовый → фиолетовый
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FF00AA"),  // ярко-розовый
                    Color(hex: "AA00FF")   // насыщенный фиолетовый
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            // светлая тема: коралловый → персиковый
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "FF6F61"),  // коралловый
                    Color(hex: "FFA07A")   // светло-персиковый
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }

    // 5) Итоги
    private var totalIncome: Double {
        store.entries.filter { $0.type == .income }.map(\.amount).reduce(0, +)
    }
    private var totalExpense: Double {
        store.entries.filter { $0.type == .expense }.map(\.amount).reduce(0, +)
    }
    private var totalNet: Double { totalIncome - totalExpense }

    var body: some View {
        ZStack {
            (isDark ? Color.black : Color(.systemBackground))
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Заголовок
                Text("Аналитика")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(isDark ? posGradient : Theme.skyGradient)

                // График
                NeonBarChartView(
                    data: data,
                    posGradient: posGradient,
                    negGradient: negGradient,
                    isDark: isDark
                )

                // Текстовая сводка
                HStack(spacing: 24) {
                    summaryBlock(title: "Доход", amount: totalIncome, gradient: posGradient, positive: true)
                    summaryBlock(title: "Расход", amount: totalExpense, gradient: negGradient, positive: false)
                    summaryBlock(title: "Баланс", amount: totalNet, gradient: totalNet >= 0 ? posGradient : negGradient, positive: totalNet >= 0)
                }
                .padding()
                .background(isDark ? Color.white.opacity(0.05) : Color(.systemGray6))
                .cornerRadius(12)

                Spacer()
            }
            .padding(.top, 32)
            .padding(.bottom, 16)
        }
    }

    // Вспомогательная вьюшка для одной карточки итога
    @ViewBuilder
    private func summaryBlock(title: String, amount: Double,
                              gradient: LinearGradient, positive: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(amount, format: .currency(code: AppFormat.currencyCode))
                .font(.headline)
                .foregroundStyle(gradient)
        }
    }
}

// Превью
struct NightNeonChartView_Previews: PreviewProvider {
    static var previews: some View {
        let store = EntryStore()
        store.add(Entry(amount: 500, category: "Test", type: .income, date: Date()))
        store.add(Entry(amount: 200, category: "Test", type: .expense, date: Date()))

        return Group {
            NightNeonChartView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
            NightNeonChartView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
        .previewDevice("iPhone 16 Pro")
    }
}
