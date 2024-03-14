//
//  Constants.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 12.3.24..
//

import SwiftUI

struct Constants {
    static let placholderParagraph = """
    Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales.
    """
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

    var imageURLString: String {
        switch self {
        case .hyperEther: "https://markom.netlify.app/static/8aa696cf7b52831460283d61d54c0c1f/logo.png"
        }
    }
}
