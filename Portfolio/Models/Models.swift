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

    static let projects: [Project] = [
        .init(
            name: "Gem + Jewel",
            category: .shopping,
            image: .gemJewel,
            description: Constants.placholderParagraph,
            technologies: Constants.technologies,
            appStoreURLString: "https://apps.apple.com/us/app/gem-jewel/id6466446330",
            videoURLString: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"
        ),
        .init(
            name: "Second App",
            category: .shopping,
            image: .launchLogo,
            description: Constants.placholderParagraph,
            technologies: Constants.technologies,
            appStoreURLString: "",
            videoURLString: ""
        )
    ]

    static let experiences: [Experience] = [.hyperEther]

    static let technologies: [Tech] = Tech.allCases

    static var backPlacement: ToolbarItemPlacement {
#if os(iOS)
        return .topBarLeading
#elseif os(macOS)
        return .navigation
#endif
    }

    static var titlePlacement: ToolbarItemPlacement {
#if os(iOS)
        return .principal
#elseif os(macOS)
        return .navigation
#endif
    }
}

protocol Skill {
    var url: String? { get }
    var imageURL: String? { get }
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

    var imageURL: String? {
        switch self {
        case .swiftUIIntrospect: return "https://avatars.githubusercontent.com/u/55716259?s=48&v=4"
        case .heresdk: return "https://www.here.com/themes/custom/here_com_theme/favicon.ico"
        case .Lottie: return "https://airbnb.io/lottie/images/logo.webp"
        case .DGCharts: return "https://avatars.githubusercontent.com/u/79675592?s=48&v=4"
        case .AlamoFire: return "https://avatars.githubusercontent.com/u/7774181?s=48&v=4"
        case .SwiftyJSON: return "https://avatars.githubusercontent.com/u/8858017?s=48&v=4"
        case .TUSKit: return "https://avatars.githubusercontent.com/u/3581905?s=48&v=4"
        case .SDWebImage: return "https://avatars.githubusercontent.com/u/33113626?s=48&v=4"
        case .MixPanel: return "https://avatars.githubusercontent.com/u/63653?s=48&v=4"
        default:
            if url?.contains("github") == true {
                return "https://github.githubassets.com/favicons/favicon-dark.png"
            } else { return nil }
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

    var imageURL: String? { nil }
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
    case postman
    case GithubDesktop = "Github Desktop"
    var id: UUID { UUID() }

    var url: String? {
        switch self {
        case .UserDefaults: "https://developer.apple.com/documentation/foundation/userdefaults"
        case .GithubDesktop: "https://desktop.github.com/"
        case .ODR: "https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/On_Demand_Resources_Guide/"
        default: nil
        }
    }

    var imageURL: String? { nil }
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

extension Project: Hashable {
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

enum Experience: String, Identifiable {
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
        case .hyperEther: "Creating iOS Apps with Swift."
        case .freelance: Constants.placholderParagraph
        }
    }

    var urlString: String? {
        switch self {
        case .hyperEther: "https://hyperether.com"
        case .freelance: nil
        }
    }

    var title: String { "iOS Developer" }

    var start: Date { .init(string: "2.2023") }
    var end: Date { .init() }
    var id: Self { self }

    var projects: [Project] { Constants.projects }
}

struct IdentifiableData: Identifiable {
    let entry: String
    let id = UUID()
}
