//
//  AttendanceErrorMsgType.swift
//  CoreDemo
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum AttendanceErrorMsgType: String, CaseIterable {
    case beforeAttendance = "출석 시작 전입니다"
    case beforeFirstAttendance = "1차 출석 시작 전입니다"
    case beforeSecondAttendance = "2차 출석 시작 전입니다"
    case afterFirstAttendance = "1차 출석이 이미 종료되었습니다."
    case afterSecondAttendance = "2차 출석이 이미 종료되었습니다."
    
    public var title: String {
        switch self {
        case .beforeAttendance, .beforeFirstAttendance:
            return I18N.Attendance.beforeFirstAttendance
        case .afterFirstAttendance, .beforeSecondAttendance:
            return I18N.Attendance.afterNthAttendance(1)
        case .afterSecondAttendance:
            return I18N.Attendance.afterNthAttendance(2)
        }
    }
 
    /*
     에러 메세지를 하단 출석하기 버튼 타이틀로 바꿔주는 메서드
     */
    public static func getTitle(for error: Error) -> String? {
        guard let errorMsg = (error as? OPAPIError)?.errorDescription else {
            return nil
        }
        
        return Self.allCases.first { $0.rawValue == errorMsg }?.title
    }
}
