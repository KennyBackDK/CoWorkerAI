// File: CoWorkerAI/CoWorkerAI/App/CoWorkerAIApp.swift
import SwiftUI

@main
struct CoWorkerAIApp: App {
    @AppStorage(UserDefaultsKeys.appTheme) private var appThemeRaw: String = AppTheme.system.rawValue

    init() {
        LoggerService.shared.info("App init")
        do {
            try AppPaths.shared.ensureAppSupportDirectory()
        } catch {
            LoggerService.shared.error("Failed to ensure app support directory: \(String(describing: error))")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .applyTheme(AppTheme(rawValue: appThemeRaw) ?? .system)
                .onAppear {
                    LoggerService.shared.debug("ContentView appeared")
                }
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Reveal Data Folder in Finder") {
                    do {
                        let url = try AppPaths.shared.appSupportDirectory()
                        NSWorkspace.shared.activateFileViewerSelecting([url])
                    } catch {
                        LoggerService.shared.error("Reveal data folder failed: \(String(describing: error))")
                    }
                }
            }
        }

        Settings {
            SettingsView()
        }
    }
}

private extension View {
    @ViewBuilder
    func applyTheme(_ theme: AppTheme) -> some View {
        switch theme {
        case .system:
            self
        case .light:
            self.preferredColorScheme(.light)
        case .dark:
            self.preferredColorScheme(.dark)
        }
    }
}

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
