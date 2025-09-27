// File: CoWorkerAI/CoWorkerAI/Settings/SettingsView.swift
import SwiftUI
import AppKit

struct SettingsView: View {
    @AppStorage(UserDefaultsKeys.apiKey) private var apiKey: String = ""
    @AppStorage(UserDefaultsKeys.appTheme) private var appThemeRaw: String = AppTheme.system.rawValue

    var body: some View {
        Form {
            Section("General") {
                HStack {
                    Text("Data Folder")
                    Spacer()
                    Text((try? AppPaths.shared.appSupportDirectory().path(percentEncoded: false)) ?? "Unavailable")
                        .font(.system(.body, design: .monospaced))
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                HStack {
                    Spacer()
                    Button("Reveal in Finder") {
                        do {
                            let url = try AppPaths.shared.appSupportDirectory()
                            NSWorkspace.shared.activateFileViewerSelecting([url])
                        } catch {
                            LoggerService.shared.error("Reveal data folder failed: \(String(describing: error))")
                        }
                    }
                }
            }

            Section("API") {
                SecureField("API Key", text: $apiKey)
            }

            Section("Appearance") {
                Picker("Theme", selection: $appThemeRaw) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.title).tag(theme.rawValue)
                    }
                }
            }
        }
        .padding()
        .frame(width: 560)
        .navigationTitle("Settings")
    }
}
