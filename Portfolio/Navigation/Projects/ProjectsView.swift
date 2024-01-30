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
            appStoreURL: "https://apps.apple.com/us/app/gem-jewel/id6466446330", 
            videoURL: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        ),
        .init(
            name: "Second",
            category: .shopping,
            image: .gemJewel, 
            description: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales",
            appStoreURL: "",
            videoURL: ""
        )
    ]
    @State var selectedId: UUID? 
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(projects) { project in
                if selectedId == nil || selectedId == project.id {
                    ProjectCardView(project: project, selectedId: $selectedId)
                }
            }
        }
        .toolbar(selectedId == nil ? .automatic : .hidden, for: .tabBar)
        .animation(.default, value: selectedId)
    }
}

#Preview {
    ProjectsView()
}
