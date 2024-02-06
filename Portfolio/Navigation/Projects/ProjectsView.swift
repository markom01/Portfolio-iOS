//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct ProjectsView: View {
    let projects: [ProjectCardView.Project] = [
        .init(
            name: "Gem + Jewel",
            category: .shopping,
            image: .gemJewel,
            description: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales", 
            technologies: [.swiftui, .uikit],
            appStoreURLString: "https://apps.apple.com/us/app/gem-jewel/id6466446330",
            videoURLString: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        ),
        .init(
            name: "Second",
            category: .shopping,
            image: .gemJewel, 
            description: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales", 
            technologies: [.swiftui],
            appStoreURLString: "https://apps.apple.com/us/app/gem-jewel/id6466446330",
            videoURLString: ""
        )
    ]
    @State var selectedId: UUID? 
    
    var body: some View {
        List(projects) { project in
            if selectedId == nil || selectedId == project.id {
                ProjectCardView(project: project, selectedId: $selectedId)
            }
        }
        .toolbar {
            if selectedId != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "chevron.left") { selectedId = nil }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .toolbar(selectedId == nil ? .visible : .hidden, for: .tabBar)
        .toolbarBackground(selectedId == nil ? .visible : .hidden, for: .tabBar)
        .animation(.default, value: selectedId)
    }
}

#Preview {
    ProjectsView()
}
