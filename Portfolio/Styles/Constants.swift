//
//  Constants.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 31.1.24..
//

import Foundation

extension CGFloat {
    static let small: Self = 10
    static let medium: Self = 20
    static let large: Self = 40
    static var topBarLogo: Self {
#if os(iOS)
        40
#elseif os(macOS)
        28
#endif
    }
}
