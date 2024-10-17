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
                .toolbarBackground(.ultraThinMaterial.opacity(0.1), for: .navigationBar, .tabBar)
                .toolbarBackground(.visible, for: .navigationBar, .tabBar)
                .background {
                    if #available(iOS 18, *) {
                        Mesh()
                            .ignoresSafeArea(edges: .all)
                            .overlay(.ultraThinMaterial)
                    } else {
                        Rectangle().fill(.ultraThinMaterial)
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
                    }
                    ToolbarItem(placement: .topBarTrailing) { navigationBarRightItem }
                }
#endif
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
