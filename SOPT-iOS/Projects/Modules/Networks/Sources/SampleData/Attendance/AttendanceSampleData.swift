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
//            return SampleData.Lecture.firstAbsentCaseOne
//            return SampleData.Lecture.absentCaseOne
//            return SampleData.Lecture.absenctCaseTwo
//            return SampleData.Lecture.tardy
//            return SampleData.Lecture.eventSession
//            return SampleData.Lecture.noAttendanceSession
            let lectureCases = [SampleData.Lecture.noSession, SampleData.Lecture.noAttendanceSession,
                                SampleData.Lecture.beforeAttendance, SampleData.Lecture.absentCaseOne, SampleData.Lecture.absenctCaseTwo,
                                SampleData.Lecture.tardyCaseOne, SampleData.Lecture.tardyCaseTwo, SampleData.Lecture.eventSession, SampleData.Lecture.firstAbsentCaseOne]
            let randomIndex = Int.random(in: 0..<lectureCases.count)
//            return lectureCases[randomIndex]
            return SampleData.Lecture.absenctCaseTwo
//            return SampleData.Lecture.attendanceComplete
//            return SampleData.Lecture.errorSession
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
            return SampleData.Attend.success
//            return SampleData.Attend.notCorrect
//            return SampleData.Attend.afterFirstAttendance
        default:
            return Data()
        }
    }
}
