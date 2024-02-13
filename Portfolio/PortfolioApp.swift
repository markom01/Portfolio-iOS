//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftData
import SafariServices

@main
struct PortfolioApp: App {
    var body: some Scene {
        WindowGroup { AppView() }
            .modelContainer(for: Preference.self)
#if os(macOS)
            .windowResizability(.contentSize)
#endif
    }
}

struct AppView: View {
    @Query var preferences: [Preference]
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationStack { TabsView() }
            .overlay {
                LaunchView(
                    backgroundColor: preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .black : .white)
            }
#if os(macOS)
            .background(.ultraThinMaterial)
            .onAppear(perform: setupWindow)
#elseif os(iOS)
            .onAppear {
                if preferences.isEmpty {
                    context.insert(Preference(isDarkMode: colorScheme == .dark))
                }
            }
            .environment(\.colorScheme, preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .dark : .light)
            .environment(\.openURL, OpenURLAction { url in
                openWebSheet(url)
                return .handled
            })
            .animation(.linear(duration: 0.3), value: preferences.first?.isDarkMode)
#endif
    }
}

extension AppView {
#if os(macOS)
    func setupWindow() {
        guard let window = NSApplication.shared.windows.first else { return }
        window.isOpaque = false
        window.backgroundColor = .clear
        window.titlebarAppearsTransparent = true
    }
#endif
    
#if os(iOS)
    func openWebSheet(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            safariVC.preferredBarTintColor = preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .black : .white
            safariVC.preferredControlTintColor = .accent
            UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true)
        }
    }
#endif
}
