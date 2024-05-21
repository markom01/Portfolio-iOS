//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SafariServices
import AVKit

@main
struct PortfolioApp: App {
    var body: some Scene {
        WindowGroup { AppView() }
#if os(macOS)
            .windowResizability(.contentSize)
#endif
    }
}

struct AppView: View {
    @AppStorage("isDarkMode") var isDarkMode = true
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabsView()
            .overlay {
                LaunchView(
                    backgroundColor: isDarkMode ? .black : .white)
            }
#if os(macOS)
            .background(.ultraThinMaterial)
            .onAppear(perform: setupWindow)
#elseif os(iOS)
            .onAppear(perform: setupTheme)
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .environment(\.openURL, OpenURLAction { url in
                openWebSheet(url)
                return .handled
            })
            .onChange(of: isDarkMode, setupTheme)
            .animation(.linear(duration: 0.3), value: isDarkMode)
            .id(isDarkMode)
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
#elseif os(iOS)
    func setupTheme() {
        UIApplication.window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        UIApplication.window?.rootViewController?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        UIApplication.shared.setAlternateIconName(isDarkMode ? nil : "AppIconLight")
        UICollectionView.appearance().allowsSelection = false
    }

    func openWebSheet(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            safariVC.preferredBarTintColor = isDarkMode ? .black : .white
            safariVC.preferredControlTintColor = .accent
            UIApplication.window?.rootViewController?.present(safariVC, animated: true)
        }
    }
#endif
}

#if os(iOS)
extension AVPlayerViewController {
    open override func viewDidLoad() {
        view.backgroundColor = .secondarySystemGroupedBackground
    }
}
#endif

#Preview {
    AppView()
}
