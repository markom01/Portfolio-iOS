//
//  SwiftDataModels.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import Foundation
import SwiftData

@Model
class Preference {
    var isDarkMode: Bool
    
    init(isDarkMode: Bool) {
        self.isDarkMode = isDarkMode
    }
}
