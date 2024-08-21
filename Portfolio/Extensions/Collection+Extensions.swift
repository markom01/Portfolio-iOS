//
//  Collection+Extensions.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 9.8.24..
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
