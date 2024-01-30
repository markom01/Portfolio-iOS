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
        VStack(alignment: .leading) {
            HStack {
                Image(project.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(project.name)
                    Text(project.category.rawValue.capitalized)
                }
                Spacer()
                Button { 
                    selectedId = selectedId == project.id ? nil : project.id
                } label: {
                    Image(
                        systemName: selectedId == project.id
                        ? "rectangle.compress.vertical"
                        : "rectangle.expand.vertical")
                }
            }
            Text(project.description).lineLimit(selectedId == project.id ? nil : 2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .border(selectedId == project.id ? .clear : .black)
    }
}

extension ProjectCardView {
    struct Project: Identifiable {
        let name: String
        let category: Category
        let image: ImageResource
        let description: String
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
            description: "Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales"
        ),
        selectedId: .constant(nil)
    )
}
