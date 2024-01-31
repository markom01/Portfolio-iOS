//
//  Constants.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 31.1.24..
//

import Foundation

extension CGFloat {
    enum Padding: CGFloat {
        case small = 10
        case medium = 20
        case large = 40
    }
    
    static func constant(_ padding: Padding) -> CGFloat { padding.rawValue }
}
