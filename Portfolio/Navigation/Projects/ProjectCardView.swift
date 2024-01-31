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
    
    var body: some View {
        let layout = selectedId == project.id ? AnyLayout(VStackLayout(spacing: 20)) : AnyLayout(HStackLayout(alignment: .bottom, spacing: 10))
        
        VStack(alignment: .leading, spacing: selectedId == project.id ? 40 : 20) {
            if selectedId == project.id {
               
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
                        Text(project.name).font(.headline)
                        Text(project.category.rawValue.capitalized).font(.subheadline)
                    }
                }
                
                Spacer()
                
                if selectedId != project.id {
                    Button { selectedId = project.id } label: {
                        Image(systemName: "chevron.right")
                    }
                }
            }
            SectionView(
                data: .init(title: "Description", text: project.description),
                isHeaderShown: selectedId == project.id
            )
            
            if selectedId == project.id {
                if let appStoreURL = URL(string: project.appStoreURL) {
                    Link("App Store", destination: appStoreURL)
                }
                
                VideoView(urlString: project.videoURL)
            }
            if selectedId != project.id {
                Divider()
            }
        }
        .frame(maxWidth: .infinity)
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
