//
//  NightNeonBarChartView.swift
//  FinanceApp
//
//
//

import SwiftUI
import Charts

/// Саб-вью, которое рисует график по готовым данным и градиентам
struct NeonBarChartView: View {
    let data: [NightNeonChartView.PeriodData]
    let posGradient: LinearGradient
    let negGradient: LinearGradient
    let isDark: Bool

    var body: some View {
        Chart {
            // пунктирная нулевая линия
            RuleMark(y: .value("Zero", 0))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundStyle(isDark ? .white.opacity(0.5) : .gray.opacity(0.7))

            // сами столбики
            ForEach(data) { item in
                BarMark(
                    x: .value("Месяц", item.label),
                    y: .value("Net",   item.net)
                )
                .cornerRadius(6)
                .foregroundStyle(item.net >= 0 ? posGradient : negGradient)
                .annotation(position: item.net >= 0 ? .top : .bottom) {
                    Text(item.net, format: .number)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisGridLine().foregroundStyle(isDark ? .white.opacity(0.2) : Color(.separator))
                AxisValueLabel().foregroundStyle(isDark ? .white : .primary)
            }
        }
        .chartYAxis {
            AxisMarks { _ in
                AxisGridLine().foregroundStyle(isDark ? .white.opacity(0.2) : Color(.separator))
                AxisValueLabel().foregroundStyle(isDark ? .white : .primary)
            }
        }
        .frame(height: 300)
        .padding(.horizontal)
    }
}
