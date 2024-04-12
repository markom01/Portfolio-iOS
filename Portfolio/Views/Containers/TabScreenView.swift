//
//  TabScreenView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct TabScreenView: View {
    let data: Data
    @Binding var appearance: ColorScheme

    var body: some View {
        NavigationStack {
            data.content
#if os(iOS)
                .toolbarBackground(.visible, for: .tabBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) { navigationBarRightItem }
                }
#endif
        }
        .tabItem {
            Label(data.navigation.title, systemImage: data.navigation.tabIcon)
        }
    }
}

// MARK: Views
extension TabScreenView {
#if os(iOS)
    var navigationBarRightItem: some View {
        SwitchView(
            isOn: Binding(
                get: { appearance == .dark },
                set: { appearance = $0 ? .dark : .light }
            )
        )
    }
#endif
}

extension TabScreenView {
    struct Data: Identifiable {
        let navigation: Navigation
        let content: AnyView
        let id = UUID()

        struct Navigation {
            let title: String
            let tabIcon: String
        }
    }
}

#Preview {
    TabScreenView(
        data: .init(
            navigation: .init(
                title: "Title", tabIcon: "placeholdertext.fill"
            ),
            content: .init(Text("Content"))
        ),
        appearance: .constant(.dark)
    )
}
