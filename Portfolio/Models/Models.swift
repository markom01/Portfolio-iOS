//
//  Models.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 12.3.24..
//

import SwiftUI

struct Constants {
    static let appScheme = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Portfolio"

    static let placholderParagraph = """
    Morbi lacinia lobortis magna nec commodo. Fusce faucibus ipsum felis, ac egestas nisi aliquam varius. Donec sed elementum turpis. Maecenas suscipit fermentum orci nec pretium. Nam at orci orci. Proin sodales.
    """

    static let projects: [Project] = [
        .init(
            name: .JM,
            category: .Insurance,
            image: .gemJewel,
            description: """
            [Jewelers Mutual](https://www.jewelersmutual.com) Consumer App for insuring and managing jewelery items.
            """,
            features: [
                .init(name: "Charts", icon: "chart.pie", description: "Pie chart view of jewelery categories by value and count."),
                .init(name: "Jewelry Box", icon: "cube.box", description: "Place to view, search, filter, add end edit personal jewelery."),
                .init(name: "Jewelery Locator", icon: "storefront", description: "Jewelers Marketplace Map where user can search for nearest jewelry store."),
                .init(name: "Jewelry Protection", icon: "shield", description: "Displaying of policies with protected jewelry items."),
                .init(name: "Shake to Report", icon: "exclamationmark.bubble", description: "Shake device to send feedback or report an issue in app.")
            ],
            technologies: [Libraries.swiftUIIntrospect, Libraries.AppAuth, AppleFrameworks.WebKit, Tech.Postman, Tech.Scrum],
            appStoreURLString: "https://apps.apple.com/us/app/gem-jewel/id6466446330",
            videoURLString: ""
        ),
        .init(
            name: .Luxsurance,
            category: .Insurance,
            image: .luxsurance,
            description: """
            [Luxsurance](https://www.luxsurance.com) App for managing luxury jewelery and connecting with retailers.
            """,
            features: [
                .init(name: "Collections", icon: "diamond", description: "Place to view, search, filter, add end edit personal jewelery."),
                .init(name: "Notifications", icon: "bell.badge", description: "In-app notifications from Jeweler about buyed jewelry and offers."),
                .init(name: "Chat", icon: "message", description: "Get in touch with retailers where jewelry is buyed.")
            ],
            technologies: [Libraries.AppAuth, Libraries.AlamoFire, Libraries.SDWebImage, AppleFrameworks.WebKit],
            appStoreURLString: "https://apps.apple.com/us/app/luxsurance/id1478032005",
            videoURLString: ""
        ),
        .init(
            name: .InBrowser,
            category: .Browser,
            image: .inBrowser,
            description: """
            iOS private browser. Each time app is closed, everything user is done will be erased, including history, cookies, and sessions.
            """,
            features: [
                .init(name: "Tornado Clear", icon: "tornado", description: "On tap of tornado, all data is deleted."),
                .init(name: "Settings", icon: "gear", description: "Contains preferences for changing browser agent, search engine and more privacy features."),
                .init(name: "Downloads", icon: "square.and.arrow.down", description: "Enables downloading of remote files."),
                .init(name: "Tabs", icon: "table", description: "Makes available switching between pages smoothly."),
                .init(name: "Search Suggestions", icon: "text.magnifyingglass", description: "Helps in search by autocompleting results while showing website favicon and title.")
            ],
            technologies: [Libraries.Lottie, Libraries.MixPanel, Libraries.swiftUIIntrospect, AppleFrameworks.WebKit, Tech.Animations],
            appStoreURLString: "https://apps.apple.com/us/app/inbrowser-private-browsing/id598907571?platform=iphone",
            videoURLString: ""
        ),
        .init(
            name: .Mory,
            category: .Assistant,
            image: .mory,
            description: "Personal AI assistant app which simplifies daily tasks like creating contacts, events, mails & more.",
            features: [
                .init(name: "Contacts", icon: "person.crop.circle", description: "Adding, editing and deleting contacts that can be imported from Google or Microsoft account."),
                .init(name: "Mail", icon: "envelope", description: "Ability to send and receive e-mails with preview-able attachemnts."),
                .init(name: "Calendar", icon: "calendar", description: "Scheduling events and preview by year, month and week agenda."),
                .init(name: "Interactive Widget", icon: "app", description: "Quick add of contacts, events, mails & more."),
                .init(name: "AI Avatar", icon: "brain", description: "User is able to talk to Mory AI and make contacts, events, mails & more.")
            ],
            technologies: [Libraries.swiftUIIntrospect, Libraries.Lottie, Libraries.TUSKit, Tech.Localization],
            videoURLString: ""
        ),
        .init(
            name: .ScanSDK,
            category: .SDK,
            image: .scanSDK,
            description: "iOS framework for scanning images and extracting text with Optical Character Recognition.",
            features: [
                .init(name: "OCR", icon: "doc.text.magnifyingglass", description: "Searches for text from image."),
                .init(
                    name: "Text Extraction",
                    icon: "text.book.closed",
                    description: "Connects specific part of text with provided key. For example, with provided license number label from driving license image, it returns license number text."
                ),
                .init(name: "Live Text", icon: "livephoto", description: "Enables [interaction with text](https://support.apple.com/en-us/120004) from image.")
            ],
            technologies: [AppleFrameworks.VisionKit, Tech.sdkDev, Tech.unitTest],
            videoURLString: ""
        ),
        .init(
            name: .TruckingHub,
            category: .Business,
            image: .truckingHub,
            description: "App for truckers to track fleet management, regulatory compliance and more.",
            features: [
                .init(name: "Calendar", icon: "calendar.day.timeline.left", description: "Custom animated calendar by week and month."),
                .init(
                    name: "Document Scanner",
                    icon: "doc.viewfinder",
                    description: .init("Uses \(Project.Name.ScanSDK.inAppURL) to find and extract information from driving license.")
                )
            ],
            technologies: [Libraries.SwiftyJSON],
            videoURLString: ""
        ),
        .init(
            name: .AlertEOS,
            category: .Medical,
            image: .alertEOS,
            description: "Alarm app for doctors and nurses to be notified about patient condition.",
            features: [
                .init(name: "Notifications", icon: "light.beacon.min", description: "Alarms are sent and received over WebSocket."),
                .init(name: "Settings", icon: "gear", description: "Admin can change connection settings directly in app.")
            ],
            technologies: [Libraries.Starscream, Libraries.SDWebImage],
            videoURLString: ""
        ),
        .init(
            name: .AirTouch,
            category: .Communication,
            image: .airtouch,
            description: "Communication app with both audio and video calls and contacts.",
            features: [
                .init(name: "Multiple Sign Up Options", icon: "person.crop.circle.badge.plus", description: "Sign up with Google, Microsoft or mail."),
                .init(name: "Contacts", icon: "book.pages", description: "List of imported contacts from phone and created in-app.")
            ],
            technologies: [Libraries.SDWebImage, Libraries.AppAuth],
            videoURLString: ""
        ),
        .init(
            name: .RushFiles,
            category: .Utils,
            image: .rushFiles,
            description: "File Cloud solution for comapnies with app branding possibility.",
            features: [
                .init(name: "File Cloud", icon: "externaldrive.badge.icloud", description: "Uploading, previewing and locking all types of files."),
                .init(name: "Folders", icon: "folder", description: "Supporting file oganization into folders and sharing link."),
                .init(name: "MS Office integration", icon: "doc", description: "Edit files from cloud in MS Office apps.")
            ],
            technologies: [AppleFrameworks.WebKit, Libraries.AlamoFire],
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
        return .principal
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
    case QuickLook
    case Cocoa = "Cocoa (Touch)"

    var url: String? {
        let baseUrl = "https://developer.apple.com/documentation/"
        let path: String? = switch self {
        case .SwiftUI: "swiftui"
        case .UIKit: "uikit"
        case .AppKit: "appkit"
        case .WebKit: "webkit"
        case .VisionKit: "visionkit"
        case .Combine: "combine"
        case .QuickLook: "quicklook"
        case .Swift, .Cocoa: nil
        }
        return baseUrl + (path ?? "")
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
    case Postman
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
    let name: Name
    let category: Category
    let image: ImageResource
    let description: LocalizedStringKey
    let features: [Feature]
    let technologies: [Skill]
    var appStoreURLString: String?
    let videoURLString: String
    let id = UUID()

    enum Category: String {
        case Insurance
        case Browser
        case Assistant
        case SDK
        case Business
        case Medical
        case Communication
        case Utils
    }

    struct Feature: Identifiable {
        let name: String
        let icon: String
        let description: LocalizedStringKey
        var id: String { name }
    }

    enum Name: String, Codable {
        case JM, Luxsurance, InBrowser, Mory, ScanSDK, AlertEOS, AirTouch
        case TruckingHub = "Trucking Hub"
        case RushFiles = "Rush Files"

        var inAppURL: String {
            "[\(rawValue)](\(Constants.appScheme)://projects/\(rawValue.replacingOccurrences(of: " ", with: "")))"
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
