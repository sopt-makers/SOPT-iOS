//
//  AttendanceUseCase.swift
//  Domain
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol AttendanceUseCase {
    func fetchLectureRound(lectureId: Int)
    func postAttendance(lectureRoundId: Int, code: Int)
    var lectureRound: PassthroughSubject<Int, Never> { get set }
    var attendSuccess: PassthroughSubject<Bool, Never> { get set }
}

public class DefaultAttendanceUseCase {
    
    private let repository: AttendanceRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var lectureRound = PassthroughSubject<Int, Never>()
    public var attendSuccess = PassthroughSubject<Bool, Never>()
    
    public init(repository: AttendanceRepositoryInterface, cancelBag: CancelBag = CancelBag()) {
        self.repository = repository
        self.cancelBag = cancelBag
    }
}

extension DefaultAttendanceUseCase: AttendanceUseCase {
    public func fetchLectureRound(lectureId: Int) {
        repository.fetchLectureRound(lectureId: lectureId)
            .sink(receiveCompletion: { event in
                switch event {
                case .failure(let error):
                    print("failure: fetchLectureRound \(error)")
                case .finished:
                    print("completion: fetchLectureRound \(event)")
                }
            }, receiveValue: { result in
                self.lectureRound.send(result)
            })
            .store(in: cancelBag)
    }
    
    public func postAttendance(lectureRoundId: Int, code: Int) {
        repository.postAttendance(lectureRoundId: lectureRoundId, code: code)
            .sink(receiveCompletion: { event in
                switch event {
                case .failure(let error):
                    print("failure: postAttendance \(error)")
                case .finished:
                    print("completion: postAttendance \(event)")
                }
            }, receiveValue: { result in
                self.attendSuccess.send(result)
            })
            .store(in: cancelBag)
    }
}
