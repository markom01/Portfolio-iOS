//
//  ProjectCardView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI

struct ProjectCardView: View {
    let project: Project
    @Binding var selectedId: UUID?
    @State var isVideoFullScreen = false
    
    var body: some View {
        let layout = selectedId == project.id ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        VStack(alignment: .leading, spacing: 20) {
            if !isVideoFullScreen {
                if selectedId == project.id {
                    Button("Back") { selectedId = nil }
                }
                
                HStack {
                    if selectedId == project.id {
                        Spacer()
                    }
                    
                    layout {
                        Image(project.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: selectedId == project.id ? 100 : 50)
                        VStack(alignment: selectedId == project.id ? .center : .leading) {
                            Text(project.name)
                            Text(project.category.rawValue.capitalized)
                        }
                    }
                    
                    Spacer()
                    
                    if selectedId != project.id {
                        Button { selectedId = project.id } label: {
                            Image(systemName: "rectangle.expand.vertical")
                        }
                    }
                }
                
                Text(project.description)
                    .lineLimit(selectedId == project.id ? nil : 2)
                
                if selectedId == project.id {
                    if let appStoreURL = URL(string: project.appStoreURL) {
                        Link("App Store", destination: appStoreURL)
                    }
                }
            }
            
            if selectedId == project.id {
                VideoView(
                    urlString: project.videoURL,
                    isVideoFullScreen: $isVideoFullScreen
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(selectedId == project.id ? 0 : 20)
        .border(selectedId == project.id ? .clear : .black)
        .animation(.default, value: isVideoFullScreen)
    }
}

extension ProjectCardView {
    struct Project: Identifiable {
        let name: String
        let category: Category
        let image: ImageResource
        let description: String
        let appStoreURL: String
        let videoURL: String
        let id = UUID()
        
        enum Category: String {
            case shopping
        }
    }
}

#Preview {
    ProjectCardView(
        project: .init(
            name: "Project Name",
            category: .shopping,
            image: .gemJewel, 
            description: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales", 
            appStoreURL: "", 
            videoURL: ""
        ),
        selectedId: .constant(nil)
    )
}
