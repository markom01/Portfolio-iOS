//
//  TabScreenView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct TabScreenView: View {
    let data: Data

    var body: some View {
            ScrollView {
                data.content
                    .padding(.top, .large)
                    .padding(.horizontal, .medium)
            }
            .scrollBounceBehavior(.basedOnSize)
        .tabItem { Label(data.navigation.title, systemImage: data.navigation.tabIcon) }
        .toolbarBackground(.visible, for: .tabBar)               
    }
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
