//
//  TabScreenView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct TabScreenView: View {
    let data: Data
    @AppStorage("isDarkMode") var isDarkMode = true

    var body: some View {
        NavigationStack {
            data.content
#if os(iOS)
                .background {
                    if #available(iOS 18, *) {
                        Mesh()
                            .ignoresSafeArea(edges: .all)
                            .overlay(.ultraThinMaterial)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HeaderView(
                            isExpanded: false,
                            headingView: .init(Text("Marko Meseldžija")),
                            subHeadingView: .init(Text("iOS Developer")),
                            imageSource: .named(.launchLogo),
                            alignment: .center
                        )
                        .scaleEffect(0.8)
                        .frame(width: 200)
                    }
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
        SwitchView(isOn: $isDarkMode)
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
        )
    )
}
