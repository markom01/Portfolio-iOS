//
//  UIApplication+Extensions.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 12.3.24..
//

import UIKit

extension UIApplication {
    static var window: UIWindow? {
        UIApplication
        .shared
        .connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .last
    }
}
