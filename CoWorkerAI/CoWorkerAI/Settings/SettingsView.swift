// File: CoWorkerAI/CoWorkerAI/Settings/SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKeys.apiKey) private var apiKey: String = ""
    @AppStorage(UserDefaultsKeys.appTheme) private var appThemeRaw: String = AppTheme.system.rawValue

    var body: some View {
        Form {
            Section(header: Text("API Key")) {
                SecureField("Enter your API key", text: $apiKey)
                    .textFieldStyle(.roundedBorder)
            }

            Section(header: Text("Theme")) {
                Picker("Appearance", selection: $appThemeRaw) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.title).tag(theme.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("Data Folder")) {
                if let url = try? AppPaths.shared.baseDirectory() {
                    HStack {
                        Text(url.path)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Spacer()
                        Button("Reveal in Finder") {
                            revealInFinder(url: url)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 400, height: 250)
    }
}
