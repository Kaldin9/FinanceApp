//
//  AppFormat.swift
//  Finance App
//
//
//

import Foundation

enum AppFormat {
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
}
