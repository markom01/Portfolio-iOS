//
//  PortfolioApp.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftData

@main
struct PortfolioApp: App {
    var body: some Scene {
        WindowGroup {
            TabsView()
        }
        .modelContainer(for: Preference.self)
#if os(macOS)
        .windowResizability(.contentSize)
#endif
    }
}
