//
//  ShowAttendanceUseCase.swift
//  Domain
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import Core

enum TodayAttendanceType: String {
    case attendance = "ATTENDANCE"
    case absent = "ABSENT"
}

public protocol ShowAttendanceUseCase {
    func fetchAttendanceSchedule()
    func fetchAttendanceScore()
    var attendanceScheduleFetched: PassthroughSubject<AttendanceScheduleModel, Error> { get set }
    var todayAttendances: PassthroughSubject<[AttendanceStepModel], Never> { get set }
    var attendanceScoreFetched: PassthroughSubject<AttendanceScoreModel, Error> { get set }
}

public class DefaultShowAttendanceUseCase {
    
    private enum Default {
        static let before: [AttendanceStepModel] = [
            .init(type: .none, title: I18N.Attendance.firstAttendance),
            .init(type: .none, title: I18N.Attendance.secondAttendance),
            .init(type: .none, title: I18N.Attendance.beforeAttendance)
        ]
    }
    
    // MARK: - Properties
  
    private let repository: ShowAttendanceRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var attendanceScheduleFetched = PassthroughSubject<AttendanceScheduleModel, Error>()
    public var todayAttendances = PassthroughSubject<[AttendanceStepModel], Never>()
    public var attendanceScoreFetched = PassthroughSubject<AttendanceScoreModel, Error>()
    
    // MARK: - Init
  
    public init(repository: ShowAttendanceRepositoryInterface) {
        self.repository = repository
    }
}

// MARK: - Methods

extension DefaultShowAttendanceUseCase: ShowAttendanceUseCase {
    
    public func fetchAttendanceSchedule() {
        self.repository.fetchAttendanceScheduleModel()
            .sink(receiveCompletion: { event in
                print("completion: fetchAttendanceSchedule \(event)")
            }, receiveValue: { model in
                self.attendanceScheduleFetched.send(model)
                if model.type == SessionType.hasAttendance.rawValue {
                    self.setAttendances(model.attendances)
                }
            })
            .store(in: cancelBag)
    }
    
    public func fetchAttendanceScore() {
        self.repository.fetchAttendanceScoreModel()
            .sink(receiveCompletion: { event in
                print("completion: fetchAttendanceScore \(event)")
            }, receiveValue: { model in
                self.attendanceScoreFetched.send(model)
            })
            .store(in: cancelBag)
    }
    
    /// [1차 출석 , 2차 출석, 출석] 각각 상태 및 타이틀 가지는 배열
    private func setAttendances(_ attendanceData: [TodayAttendanceModel]) {
        var attendances: [AttendanceStepModel] = []
        
        /// 출석 전
        if attendanceData.isEmpty {
            self.todayAttendances.send(Default.before)
            return
        }
        else {
            for (idx, attendance) in attendanceData.enumerated() {
                let type: AttendanceStepType = (attendance.status == TodayAttendanceType.attendance.rawValue) ? .check : .none
                let title: String = (type == .none) ? "\(idx+1)" + I18N.Attendance.nthAttendance : attendance.attendedAt
                
                attendances.append(AttendanceStepModel(type: type, title: title))
            }
        }
        
        /// 1차 출석 후
        if attendances.count == 1 {
            attendances.append(AttendanceStepModel(type: .none, title: I18N.Attendance.secondAttendance))
            attendances.append(AttendanceStepModel(type: .none, title: I18N.Attendance.beforeAttendance))
        }
        /// 2차 출석 후
        else {
            /// 2차 출석 안한 경우, 결석
            if attendances[safe: 1]?.type == AttendanceStepType.none {
                attendances.append(AttendanceStepModel(type: .none, title: I18N.Attendance.absent))
            } else {
                /// 1차 출석 안하고, 2차 출석한 경우 지각
                if attendances[safe: 0]?.type == AttendanceStepType.none {
                    attendances.append(AttendanceStepModel(type: .tardy, title: I18N.Attendance.tardy))
                }
                /// 1차 출석, 2차 출석 모두 한 경우 출석완료
                else {
                    attendances.append(AttendanceStepModel(type: .done, title: I18N.Attendance.completeAttendance))
                }
            }
        }
        
        self.todayAttendances.send(attendances)
    }
}
