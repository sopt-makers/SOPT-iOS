//
//  Date+.swift
//  Core
//
//  Created by sejin on 2023/04/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public extension Date {
    /// Create a date from specified parameters
    ///
    /// - Parameters:
    ///   - year: The desired year
    ///   - month: The desired month
    ///   - day: The desired day
    /// - Returns: A `Date` object
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone.current
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let usaDate = calendar.date(from: dateComponents)
        return usaDate!.addingTimeInterval(9 * 60 * 60)
    }
}
