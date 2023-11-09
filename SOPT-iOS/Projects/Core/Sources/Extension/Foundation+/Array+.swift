//
//  Array+.swift
//  Core
//
//  Created by sejin on 2023/04/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public extension Array {
    subscript (safe index: Index) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

public extension Array<URLQueryItem> {
    func getQueryValue(key: String) -> String? {
        return self.first(where: { $0.name == key })?.value
    }
}
