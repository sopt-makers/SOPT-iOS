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
    func fetchLectureRound(lectureId: Int)
    var attendanceScheduleFetched: PassthroughSubject<AttendanceScheduleModel, Error> { get set }
    var todayAttendances: PassthroughSubject<[AttendanceStepModel], Never> { get set }
    var attendanceScoreFetched: PassthroughSubject<AttendanceScoreModel, Error> { get set }
    var lectureRound: PassthroughSubject<AttendanceRoundModel?, Never> { get set }
    var lectureRoundErrorTitle: PassthroughSubject<String, Never> { get set }
}

public class DefaultShowAttendanceUseCase {
    
    private enum Default {
        static let before: [AttendanceStepModel] = [
            .init(type: .none, title: I18N.Attendance.nthAttendance(1)),
            .init(type: .none, title: I18N.Attendance.nthAttendance(2)),
            .init(type: .none, title: I18N.Attendance.beforeAttendance)
        ]
    }
    
    // MARK: - Properties
  
    private let repository: ShowAttendanceRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var attendanceScheduleFetched = PassthroughSubject<AttendanceScheduleModel, Error>()
    public var todayAttendances = PassthroughSubject<[AttendanceStepModel], Never>()
    public var attendanceScoreFetched = PassthroughSubject<AttendanceScoreModel, Error>()
    public var lectureRound = PassthroughSubject<AttendanceRoundModel?, Never>()
    public var lectureRoundErrorTitle = PassthroughSubject<String, Never>()
    
    // MARK: - Init
  
    public init(repository: ShowAttendanceRepositoryInterface) {
        self.repository = repository
    }
}

// MARK: - Methods

extension DefaultShowAttendanceUseCase: ShowAttendanceUseCase {
    
    public func fetchAttendanceSchedule() {
        self.repository.fetchAttendanceScheduleModel()
            .withUnretained(self)
            .sink(receiveCompletion: { event in
                print("completion: fetchAttendanceSchedule \(event)")
            }, receiveValue: { owner, model in
                owner.attendanceScheduleFetched.send(model)
                /// 출석 점수 반영되는 날만 출석 프로그레스바 정보 필요
                if model.type == SessionType.hasAttendance.rawValue {
                    owner.setAttendances(model.attendances)
                }
                /// 출석하는 날(세미나, 행사, 솝커톤, 데모데이)에 출석버튼 보이게
                if model.type != SessionType.noSession.rawValue {
                    owner.fetchLectureRound(lectureId: model.id)
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
    
    public func fetchLectureRound(lectureId: Int) {
        repository.fetchLectureRound(lectureId: lectureId)
            .catch({ error in
                if let errorMsg = AttendanceErrorMsgType.getTitle(for: error) {
                    self.lectureRoundErrorTitle.send(errorMsg)
                }
                
                return Just<AttendanceRoundModel?>(nil)
            })
            .sink(receiveCompletion: { event in
                print("completion: fetchLectureRound \(event)")
            }, receiveValue: { result in
                self.lectureRound.send(result)
            })
            .store(in: cancelBag)
    }
    
    /*
     각 출석 상태 나타내는 배열로 바꿔주는 메서드
     */
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
                let title: String = (type == .none) ? I18N.Attendance.nthAttendance(idx+1) : attendance.attendedAt
                
                attendances.append(AttendanceStepModel(type: type, title: title))
            }
        }
        
        /// 1차 출석 후
        if attendances.count == 1 {
            attendances.append(AttendanceStepModel(type: .none, title: I18N.Attendance.nthAttendance(2)))
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
