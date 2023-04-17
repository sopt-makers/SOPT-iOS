//
//  ShowAttendanceUseCase.swift
//  Domain
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import Core

public protocol ShowAttendanceUseCase {
    func fetchAttendanceSchedule()
    func fetchAttendanceScore()
    var attendanceScheduleFetched: PassthroughSubject<AttendanceScheduleModel, Error> { get set }
    var attendanceScoreFetched: PassthroughSubject<AttendanceScoreModel, Error> { get set }
}

public class DefaultShowAttendanceUseCase {
  
    private let repository: ShowAttendanceRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var attendanceScheduleFetched = PassthroughSubject<AttendanceScheduleModel, Error>()
    public var attendanceScoreFetched = PassthroughSubject<AttendanceScoreModel, Error>()
  
    public init(repository: ShowAttendanceRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultShowAttendanceUseCase: ShowAttendanceUseCase {
    public func fetchAttendanceSchedule() {
        self.repository.fetchAttendanceScheduleModel()
            .sink(receiveCompletion: { event in
                print("completion: fetchAttendanceSchedule \(event)")
            }, receiveValue: { model in
                self.attendanceScheduleFetched.send(model)
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
}
