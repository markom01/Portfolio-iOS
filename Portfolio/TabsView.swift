//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftData

struct TabsView: View {
    let tabs: [TabScreenView.Data] = [
        .init(
            navigation: .init(
                title: "Projects", tabIcon: "folder"
            ), 
            content: .init(ProjectsView())
        ),
        .init(
            navigation: .init(
                title: "Skills", tabIcon: "star"
            ),
            content: .init(Text("B"))
        ),
        .init(
            navigation: .init(
                title: "About", tabIcon: "person"
            ), 
            content: .init(Text("B"))
        ),

    ]
    
    var body: some View {
        TabView {
            ForEach(tabs) { TabScreenView(data: $0) }
        }
    }
}

#Preview {
    TabsView()
}
