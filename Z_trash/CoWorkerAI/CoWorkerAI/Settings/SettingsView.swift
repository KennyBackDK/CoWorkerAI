import SwiftUI

struct SettingsView: View {
    @AppStorage("apiKey") private var apiKey: String = ""
    @AppStorage("useDarkMode") private var useDarkMode: Bool = false

    var body: some View {
        Form {
            Section(header: Text("App")) {
                Toggle("Dark Mode", isOn: $useDarkMode)
            }
            Section(header: Text("API")) {
                SecureField("API Key", text: $apiKey)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    #endif
            }
            Section(header: Text("Filer")) {
                Button {
                    let url = ensureDataFolder()
                    reveal(url)
                } label: {
                    Label("Vis data-mappe", systemImage: "folder")
                }
            }
        }
        .navigationTitle("Indstillinger")
    }

    private func ensureDataFolder() -> URL {
        let fm = FileManager.default
        #if os(macOS)
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let app  = base.appendingPathComponent(Bundle.main.bundleIdentifier ?? "CoWorkerAI", isDirectory: true)
        #else
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let app  = base.appendingPathComponent("CoWorkerAI", isDirectory: true)
        #endif
        if !fm.fileExists(atPath: app.path) {
            try? fm.createDirectory(at: app, withIntermediateDirectories: true)
        }
        return app
    }
}

#Preview {
    NavigationStack { SettingsView() }
}

#if canImport(AppKit)
import AppKit
private func reveal(_ url: URL) { NSWorkspace.shared.activateFileViewerSelecting([url]) }
#elseif canImport(UIKit)
import UIKit
private func reveal(_ url: URL) { UIApplication.shared.open(url, options: [:], completionHandler: nil) }
#else
private func reveal(_ url: URL) {}
#endif
