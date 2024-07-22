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
        WindowGroup {
            AppView()
#if os(macOS)
                .navigationTitle("")
                .frame(minWidth: 400, maxWidth: 900, maxHeight: 700)
#endif
        }
#if os(macOS)
        .defaultSize(width: 800, height: 400)
        .windowResizability(.contentSize)
#endif
    }
}

struct AppView: View {
    @AppStorage("isDarkMode") var isDarkMode = true
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabsView()
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
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = blurEffect
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().clipsToBounds = true
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundEffect = blurEffect
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
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
