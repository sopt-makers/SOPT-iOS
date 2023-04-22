//
//  AttendanceSampleData.swift
//  Network
//
//  Created by 김영인 on 2023/04/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

extension AttendanceAPI {
    
    public var sampleData: Data {
        switch self {
        case .lecture:
//            return SampleData.Lecture.noSession
//            return SampleData.Lecture.beforeAttendance
//            return SampleData.Lecture.absentCaseOne
//            return SampleData.Lecture.absenctCaseTwo
//            return SampleData.Lecture.tardy
//            return  SampleData.Lecture.eventSession
//            return SampleData.Lecture.noAttendanceSession
            return SampleData.Lecture.attendanceComplete
        case .total:
            return SampleData.Total.success
        case .lectureRound:
//            return SampleData.LectureRound.beforeAttendance
//            return SampleData.LectureRound.beforeFirstAttendance
//            return SampleData.LectureRound.firstAttendance
//            return SampleData.LectureRound.afterFirstAttendance
//            return SampleData.LectureRound.beforeSecondAttendance
            return SampleData.LectureRound.secondAttendance
//            return SampleData.LectureRound.afterSecondAttendance
        case .attend:
//            return SampleData.Attend.success
//            return SampleData.Attend.notCorrect
            return SampleData.Attend.afterFirstAttendance
        default:
            return Data()
        }
    }
}
