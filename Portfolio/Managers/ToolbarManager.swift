//
//  ToolbarManager.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 21.2.24..
//

import SwiftUI

@Observable class ToolbarManager {
    var back = Item(placement: backPlacement)
    var projectBar = Item(placement: projectBarPlacement)
}

extension ToolbarManager {
    static var backPlacement: ToolbarItemPlacement {
#if os(iOS)
        return .topBarLeading
#elseif os(macOS)
        return .navigation
#endif
    }
    
    static var projectBarPlacement: ToolbarItemPlacement {
#if os(iOS)
        .bottomBar
#elseif os(macOS)
        .automatic
#endif
    }
    
    static let shared = ToolbarManager()
}

extension ToolbarManager {
    struct Item {
        var placement: ToolbarItemPlacement
        var view: AnyView?
        var visibility: Visibility?
    }
}
