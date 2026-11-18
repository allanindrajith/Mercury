import SwiftUI
import AppKit

@main
struct NotchBuddyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
        #if !APPSTORE
        .commands {
            // ⌘, and Mercury → Settings… open the notch's pages of the Mercury window.
            CommandGroup(replacing: .appSettings) {
                Button(NSLocalizedString("Settings…", comment: "")) {
                    delegate.openSettings()
                }
                .keyboardShortcut(",")
            }
        }
        #endif
    }
}
