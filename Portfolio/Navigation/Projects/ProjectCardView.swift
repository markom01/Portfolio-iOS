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
            }
        }
        .padding(.vertical, selectedId == project.id ? 10 : 5)
        .contentShape(Rectangle())
        .onTapGesture { selectedId = project.id }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        ImageView(source: .systemImage("person"), size: 10)
                        Text("Role")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    Text("Developer").font(.footnote)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                ShareView(urlString: project.appStoreURLString, title: "App Store")
            }
        }
        .toolbar(selectedId == project.id ? .visible : .hidden, for: .bottomBar)
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
                ImageView(
                    source: .named(project.image),
                    size: selectedId == project.id ? 100 : 50
                )
                VStack(alignment: selectedId == project.id ? .center : .leading, spacing: 5) {
                    Text(project.name)
                        .font(selectedId == project.id ? .title : .headline)
                        .fontWeight(.semibold)
                    HStack(spacing: 5) {
                        if selectedId != project.id {
                            Image(systemName: project.category.icon)
                        }
                        Text(project.category.rawValue.capitalized)
                        if selectedId == project.id {
                            Text("App")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if selectedId != project.id {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.accent)
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
            Text(project.description)
                .lineLimit(selectedId == project.id ? nil : 2)
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
                        ImageView(source: .named(tech.image), size: 50)
                        Text(tech.rawValue).font(.callout)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var preview: SectionView<VideoView>? {
        if let videoURL = URL(string: project.videoURLString) {
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
        let appStoreURLString: String
        let videoURLString: String
        let id = UUID()
        
        enum Category: String {
            case shopping
            
            var icon: String {
                switch self {
                case .shopping: "bag"
                }
            }
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
            appStoreURLString: "",
            videoURLString: ""
        ),
        selectedId: .constant(nil)
    )
}
