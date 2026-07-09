//
//  DateFormatType.swift
//  Core
//
//  Created by 강윤서 on 3/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum DateFormatType: String {
    case iso = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case isoWithoutMillis = "yyyy-MM-dd'T'HH:mm:ss"
    case dateTimeDash = "yyyy-MM-dd HH:mm:ss"
    case dateWithDot = "yyyy.MM.dd"
    case dateWithDash = "yyyy-MM-dd"
    case dateWithSlash = "yy/MM/dd"
    case monthDayWeek = "M월 d일 EEEE"
    case monthDayWeekTime = "M월 d일 EEEE H:mm"
    case monthDayWeekFullTime = "M월 d일 EEEE HH:mm"
    case monthDayWithDot = "MM.dd"
    case monthDayWIthDash = "MM-dd"
    case time = "HH:mm"
    case networkLogger = "dd/MM/yyyy HH:mm:ss"    
}
