//
//  Date+Extensions.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 14.3.24..
//

import Foundation

extension Date {
    init(string: String) {
        self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.yyyy"
        if let date = dateFormatter.date(from: string) {
            self = date
        }
    }
}
