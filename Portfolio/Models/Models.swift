//
//  Models.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 12.3.24..
//

import SwiftUI

struct Constants {
    static let placholderParagraph = """
    Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales.
    """
    static let experiences: [Experience] = [
        .init(
            company: .hyperEther,
            start: .init(string: "2.2023"),
            end: Date(),
            tech: technologies
        ),
        .init(
            company: .freelance,
            start: .init(string: "5.2023"),
            end: Date(),
            tech: technologies
        )
    ]

    static let technologies: [Tech] = [.swiftui, .uikit, .swiftui, .uikit, .uikit, .swiftui, .swiftui, .swiftui]
}

enum Tech: String, Identifiable {
    case swiftui = "SwiftUI"
    case uikit = "UIKit"
    var id: UUID { UUID() }
}

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
}

enum Company: String {
    case hyperEther = "HyperEther"
    case freelance

    var imageURLString: String {
        switch self {
        case .hyperEther: "https://www.hyperether.com/assets/public/assets/images/logo.png"
        case .freelance: "https://markom.netlify.app/static/855302e40d961b41803ea6e11e7d25da/Logo.svg"
        }
    }
}

struct Experience: Identifiable {
    let title: String = "iOS Developer"
    let company: Company
    let start: Date
    let end: Date
//        let projects: [Project]
    let tech: [Tech]
    let id = UUID()
}
