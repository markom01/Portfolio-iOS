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
