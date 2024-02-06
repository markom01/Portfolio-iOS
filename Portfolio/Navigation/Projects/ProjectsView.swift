//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import _AVKit_SwiftUI

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
            name: "Gem + Jewel",
            category: .shopping,
            image: .gemJewel,
            description: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales",
            technologies: [.swiftui, .uikit],
            appStoreURLString: "",
            videoURLString: ""
        )
    ]
    @State var selectedId: UUID? 
    @State var player = AVPlayer()
    
    var body: some View {
        List(projects) { project in
            if selectedId == nil || selectedId == project.id {
                ProjectCardView(project: project, selectedId: $selectedId, player: player)
            }
        }
        .toolbar {
            if selectedId != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "chevron.left") { selectedId = nil }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 5) {
                            ImageView(source: .systemImage("person"), size: 10)
                            Text("Role")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        Text("Developer").font(.footnote)
                    }
                    
                    Spacer()
                    
                    if let appStoreURLString = projects.first(where: { $0.id == selectedId })?.appStoreURLString,
                    let appStoreURL = URL(string: appStoreURLString) {
                        Link("App Store", destination: appStoreURL)
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .toolbar(selectedId != nil ? .visible : .hidden, for: .bottomBar)
        .toolbar(selectedId == nil ? .visible : .hidden, for: .tabBar)
        .onChange(of: selectedId) {
            if selectedId != nil {
                let selectedVideoUrlString = projects.first { $0.id == selectedId }?.videoURLString
                if let selectedVideoUrlString,
                    let videoURL = URL(string: selectedVideoUrlString) {
                    player.isMuted = true
                    player.replaceCurrentItem(with: .init(url: videoURL))
                }
            }
        }
        .animation(.default, value: selectedId)
    }
}

#Preview {
    ProjectsView()
}
