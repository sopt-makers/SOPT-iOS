//
//  DateFormatterManager.swift
//  Core
//
//  Created by 강윤서 on 3/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public final class DateFormatManager {
    public static let shared = DateFormatManager()
    
    private init() {
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    }
    
    private var formatter = DateFormatter()
}

public extension DateFormatManager {
    func setFormat(_ format: DateFormatType) {
        formatter.dateFormat = format.rawValue
    }
    
    /// 문자열을 원하는 포맷의 Date타입으로 변환
    func stringToDate(_ value: String) -> Date? {
        return formatter.date(from: value)
    }
    
    /// date타입을 원하는 포맷의 문자열로 변환
    func dateToString(_ date: Date) -> String {
        return formatter.string(from: date)
    }
    
    /// 문자열 날짜를 원하는 포맷의 String타입으로 변환
    /// 변경할 값이 비어있다면 오늘 날짜를 반환
    func transformDateFormat(_ target: String? = nil, from before: DateFormatType? = nil, to after: DateFormatType) -> String {
        guard let target, let before
        else {
            setFormat(after)
            return dateToString(Date())
        }
            
        setFormat(before)
        guard let date = stringToDate(target) else { return "00:00" }
            
        setFormat(after)
        return formatter.string(from: date)
    }
    
    /// 서버에서 내려주는 iSO 포맷 타입을 원하는 타입으로 변환
    func serverTimeToString(_ target: String, from format: DateFormatType, to serverFormat: DateFormatType = .iso) -> String {
        setFormat(serverFormat)
        guard let date = stringToDate(target) else { return "" }
        
        setFormat(format)
        return dateToString(date)
    }
    
    /// 시작 날짜와 종료 날짜 입력 받아 원하는 포맷으로 변경 후 문자열로 반환
    func formatTimeInterval(start: String, end: String) -> String {
        setFormat(.monthDayWeekFullTime)
    
        guard let startDate = stringToDate(start),
              let endDate = stringToDate(end)
        else { return "" }
        
        let startString = dateToString(startDate)
        
        setFormat(.time)
        let endString = dateToString(endDate)
        
        return "\(startString) ~ \(endString)"
    }
}
