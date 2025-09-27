// File: CoWorkerAI/CoWorkerAI/Settings/AppConfig.swift
import Foundation

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

enum UserDefaultsKeys {
    static let apiKey = "com.kennyback.coworkerai.settings.apiKey"
    static let appTheme = "com.kennyback.coworkerai.settings.appTheme"
}
