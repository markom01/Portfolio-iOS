//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SafariServices

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
    @State var appearance: ColorScheme = .dark
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack { TabsView(appearance: $appearance) }
            .overlay {
                LaunchView(
                    backgroundColor: appearance == .dark ? .black : .white)
            }
#if os(macOS)
            .background(.ultraThinMaterial)
            .onAppear(perform: setupWindow)
#elseif os(iOS)
            .environment(\.colorScheme, appearance == .dark ? .dark : .light)
            .environment(\.openURL, OpenURLAction { url in
                openWebSheet(url)
                return .handled
            })
            .animation(.linear(duration: 0.3), value: appearance)
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
            safariVC.preferredBarTintColor = appearance == .dark ? .black : .white
            safariVC.preferredControlTintColor = .accent
            UIApplication.shared.keyWindow?.rootViewController?.present(safariVC, animated: true)
        }
    }
#endif
}
