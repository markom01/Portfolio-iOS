//
//  ProjectsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftUIIntrospect
import _AVKit_SwiftUI

struct ProjectsView: View {
    @State var selectedId: UUID?
#if os(macOS)
    @State var hoveredId: UUID?
#endif
    @State var searchTerm = ""
    @State var player = AVPlayer()
    
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
            name: "Second App",
            category: .shopping,
            image: .launchLogo,
            description: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales",
            technologies: [.swiftui, .uikit],
            appStoreURLString: "",
            videoURLString: ""
        )
    ]
    
    var filteredProjects: [ProjectCardView.Project] {
           if searchTerm.isEmpty {
               return projects
           } else {
               return projects.filter { $0.name.contains(searchTerm) }
           }
       }
    
    var body: some View {
        List(filteredProjects) { project in
            if selectedId == nil || selectedId == project.id {
                ProjectCardView(project: project, selectedId: $selectedId, player: player)
#if os(macOS)
                    .padding(10)
                    .onHover {
                        hoveredId = $0 ? project.id : nil
                    }
                    .background {
                        Color.white
                            .opacity(hoveredId == project.id && selectedId != project.id ? 0.05 : 0)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
#endif
            }
        }
        .toolbar {
            if selectedId != nil {
                ToolbarItem { Spacer() }
            }
        }
        .onChange(of: selectedId, loadProjectVideo)
#if os(iOS)
        .introspect(.list, on: .iOS(.v17)) {
            $0.contentInset.top = 20
        }
        .toolbar(selectedId == nil ? .visible : .hidden, for: .tabBar)
#elseif os(macOS)
        .scrollContentBackground(.hidden)
        .listStyle(.sidebar)
        .background(.ultraThickMaterial)
        .background {
            if let hoveredImage = projects.first(where: { $0.id == hoveredId || $0.id == selectedId })?.image {
                Image(hoveredImage)
                    .resizable()
                    .opacity(0.75)
            }
        }
        .animation(.linear(duration: 0.75), value: hoveredId)
#endif
        .animation(.default, value: selectedId)
    }
}

// MARK: Logic
extension ProjectsView {
    func loadProjectVideo() {
        if selectedId != nil {
            let selectedVideoUrlString = projects.first { $0.id == selectedId }?.videoURLString
            if let selectedVideoUrlString,
                let videoURL = URL(string: selectedVideoUrlString) {
                player.isMuted = true
                player.replaceCurrentItem(with: .init(url: videoURL))
            }
        }
    }
}

#Preview {
    ProjectsView()
}
