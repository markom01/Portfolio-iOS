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
        VStack(alignment: .leading, spacing: selectedId == project.id ? .large : .medium) {
            header
            descriptiom
            if selectedId == project.id {
                techStack
                preview
            } else {
                Divider()
            }
        }
        .frame(maxWidth: .infinity)
        .onTapGesture { selectedId = project.id }
        .toolbar {
            if selectedId == project.id {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "chevron.left") { selectedId = nil }
                }
                
                if let appStoreURL = URL(string: project.appStoreURL) {
                    ToolbarItem(placement: .topBarTrailing) {
                        Link("App Store", destination: appStoreURL)
                    }
                }
            }
        }
    }
    
    var header: some View {
        let layout = selectedId == project.id
        ? AnyLayout(VStackLayout(spacing: .small))
        : AnyLayout(HStackLayout(alignment: .bottom, spacing: .small))
        
        return HStack {
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
    }
}

extension ProjectCardView {
    // MARK: Sections

    var descriptiom: SectionView<some View> {
        SectionView(
            header: "Description",
            isHeaderShown: selectedId == project.id
        ) {
            Text(project.description).lineLimit(selectedId == project.id ? nil : 2)
        }
    }
    
    var techStack: SectionView<some View> {
        SectionView(
            header: "Tech Stack",
            isHeaderShown: selectedId == project.id
        ) {
            HStack(spacing: .medium) {
                ForEach(project.technologies) { tech in
                    VStack {
                        Image(tech.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                        Text(tech.rawValue).font(.callout)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var preview: SectionView<VideoView>? {
        if let videoURL = URL(string: project.videoURL) {
            SectionView(header: "Preview", isHeaderShown: selectedId == project.id) {
                VideoView(url: videoURL)
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
        let technologies: [Tech]
        let appStoreURL: String
        let videoURL: String
        let id = UUID()
        
        enum Category: String {
            case shopping
        }
        
        enum Tech: String, Identifiable {
            case swiftui = "SwiftUI"
            case uikit = "UIKit"
            
            var image: ImageResource {
                switch self {
                case .swiftui: return .gemJewel
                case .uikit: return .gemJewel
                }
            }
            
            var id: UUID { UUID() }
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
            technologies: [.swiftui, .uikit],
            appStoreURL: "",
            videoURL: ""
        ),
        selectedId: .constant(nil)
    )
}
