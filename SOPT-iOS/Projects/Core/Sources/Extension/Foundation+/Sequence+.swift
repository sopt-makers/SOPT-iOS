//
//  Sequence+.swift
//  Core
//
//  Created by sejin on 2023/11/24.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public extension Sequence where Element: Hashable {

    /// Return the sequence with all duplicates removed.
    ///
    /// i.e. `[ 1, 2, 3, 1, 2 ].uniqued() == [ 1, 2, 3 ]`
    ///
    /// - note: Taken from stackoverflow.com/a/46354989/3141234, as
    ///         per @Alexander's comment.
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}
