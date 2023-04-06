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
