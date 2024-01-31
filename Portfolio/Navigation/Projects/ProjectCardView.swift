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
        let layout = selectedId == project.id
        ? AnyLayout(
            VStackLayout(spacing: .constant(.small))
        )
        : AnyLayout(
            HStackLayout(alignment: .bottom, spacing: .constant(.small))
        )
        
        VStack(alignment: .leading, spacing: selectedId == project.id ? .constant(.large) : .constant(.medium)) {
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
                        Text(project.name).font(selectedId == project.id ? .title : .headline)
                        HStack(spacing: 5) {
                            if selectedId == project.id {
                                Text("Category:")
                            }
                            Text(project.category.rawValue.capitalized)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
                
                if selectedId != project.id {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.blue)
                        .padding(.horizontal)
                }
            }
            SectionView(
                header: "Description",
                isHeaderShown: selectedId == project.id
            ) {
                Text(project.description).lineLimit(selectedId == project.id ? nil : 2)
            }
            
            if selectedId == project.id {
                
                SectionView(
                    header: "Tech Stack",
                    isHeaderShown: selectedId == project.id
                ) {
                    HStack {
                        VStack {
                            Image(.gemJewel)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                            Text("Swift").font(.callout)
                        }
                        VStack {
                            Image(.gemJewel)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                            Text("Swift").font(.callout)
                        }
                    }
                }
                
                VideoView(urlString: project.videoURL)
            }
            if selectedId != project.id {
                Divider()
            }
        }
        .frame(maxWidth: .infinity)
        .onTapGesture { selectedId = project.id }
        .toolbar {
            if selectedId == project.id {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") { selectedId = nil }
                }
                
                if let appStoreURL = URL(string: project.appStoreURL) {
                    ToolbarItem(placement: .topBarTrailing) {
                        Link("App Store", destination: appStoreURL)
                    }
                }
            }
        }
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
