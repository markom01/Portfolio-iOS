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

    static let technologies: [Tech] = Tech.allCases

    static var backPlacement: ToolbarItemPlacement {
#if os(iOS)
        return .topBarLeading
#elseif os(macOS)
        return .navigation
#endif
    }
}

protocol Skill {
    var url: String? { get }
    var rawValue: String { get }
}

enum Libraries: String, CaseIterable, Skill {
    case swiftUIIntrospect = "SwiftUI Introspect"
    case Lottie
    case DGCharts
    case AlamoFire
    case SwiftyJSON
    case AppAuth
    case heresdk = "Here Maps SDK"
    case TUSKit
    case SwiftLint
    case SDWebImage
    case Starscream
    case TinyConstraints
    case MixPanel

    var url: String? {
        switch self {
        case .swiftUIIntrospect: "https://github.com/siteline/swiftui-introspect"
        case .AlamoFire: "https://github.com/Alamofire/Alamofire"
        case .SwiftyJSON: "https://github.com/SwiftyJSON/SwiftyJSON"
        case .DGCharts: "https://github.com/ChartsOrg/Charts"
        case .Lottie: "https://github.com/airbnb/lottie-ios"
        case .AppAuth: "https://github.com/openid/AppAuth-iOS"
        case .TUSKit: "https://github.com/tus/TUSKit"
        case .heresdk: "https://www.here.com/platform/here-sdk"
        case .SwiftLint: "https://github.com/realm/SwiftLint"
        case .SDWebImage: "https://github.com/SDWebImage/SDWebImage"
        case .Starscream: "https://github.com/daltoniam/Starscream"
        case .MixPanel: "https://github.com/mixpanel/mixpanel-swift"
        case .TinyConstraints: "https://github.com/roberthein/TinyConstraints"
        }
    }
}

enum AppleFrameworks: String, CaseIterable, Skill {
    case Swift
    case SwiftUI
    case UIKit
    case AppKit
    case WebKit
    case VisionKit
    case Combine
    case Cocoa = "Cocoa (Touch)"

    var url: String? {
        switch self {
        case .SwiftUI: "https://developer.apple.com/xcode/swiftui"
        case .UIKit: "https://developer.apple.com/documentation/uikit#overview"
        case .AppKit: "https://developer.apple.com/documentation/appkit"
        case .WebKit: "https://developer.apple.com/documentation/webkit"
        case .VisionKit: "https://developer.apple.com/documentation/visionkit"
        case .Combine: "https://developer.apple.com/documentation/combine"
        case .Swift, .Cocoa: nil
        }
    }
}

enum Tech: String, Identifiable, CaseIterable, Skill {
    case MVVM
    case MVC
    case Animations
    case hig = "Human Interface Guidelines"
    case sdkDev = "SDK Development"
    case unitTest = "Unit Testing"
    case Localization
    case WebSocket
    case ODR = "On-Demand Resources"
    case UserDefaults
    case Scrum
    case spm = "Swift Package Manager"
    case pods = "CocoaPods"
    case GithubDesktop = "Github Desktop"
    var id: UUID { UUID() }

    var url: String? {
        switch self {
        case .UserDefaults: "https://developer.apple.com/documentation/foundation/userdefaults"
        case .GithubDesktop: "https://desktop.github.com/"
        case .ODR: "https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/"
        case .MVVM, .MVC, .sdkDev, .unitTest, .Scrum, .WebSocket, .Animations, .Localization, .spm, .pods, .hig: nil
        }
    }
}

struct Project: Identifiable {
    let name: String
    let category: Category
    let image: ImageResource
    let description: String
    let technologies: [Skill]
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

    var technologies: [Skill] {
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
    let tech: [Skill]
    let id = UUID()
}

struct IdentifiableData: Identifiable {
    let entry: String
    let id = UUID()
}
