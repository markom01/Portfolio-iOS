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

    static var backPlacement: ToolbarItemPlacement {
#if os(iOS)
        return .topBarLeading
#elseif os(macOS)
        return .navigation
#endif
    }
}

enum Tech: String, Identifiable {
    case swiftui = "SwiftUI"
    case uikit = "UIKit"
    var id: UUID { UUID() }

    var url: String {
        switch self {
        case .swiftui: "https://developer.apple.com/xcode/swiftui"
        case .uikit: "https://developer.apple.com/documentation/uikit#overview"
        }
    }
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

    var logo: ImageView.Source {
        switch self {
        case .hyperEther: .url("https://www.hyperether.com/assets/public/assets/images/logo.png")
        case .freelance: .named(.freelance)
        }
    }

    var technologies: [Tech] {
        switch self {
        case .hyperEther: Constants.technologies
        case .freelance: Constants.technologies
        }
    }

    var about: String {
        switch self {
        case .hyperEther: Constants.placholderParagraph
        case .freelance: Constants.placholderParagraph
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

struct IdentifiableData: Identifiable {
    let entry: String
    let id = UUID()
}
