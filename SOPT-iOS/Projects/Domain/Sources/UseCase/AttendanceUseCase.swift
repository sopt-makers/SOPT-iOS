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
    func postAttendance(lectureRoundId: Int, code: String)
    var attendSuccess: PassthroughSubject<Bool, Never> { get set }
    var attendErrorMsg: PassthroughSubject<String, Never> { get set }
}

public class DefaultAttendanceUseCase {
    
    private let repository: AttendanceRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var attendSuccess = PassthroughSubject<Bool, Never>()
    public var attendErrorMsg = PassthroughSubject<String, Never>()
    
    public init(repository: AttendanceRepositoryInterface, cancelBag: CancelBag = CancelBag()) {
        self.repository = repository
        self.cancelBag = cancelBag
    }
}

extension DefaultAttendanceUseCase: AttendanceUseCase {
    
    public func postAttendance(lectureRoundId: Int, code: String) {
        repository.postAttendance(lectureRoundId: lectureRoundId, code: code)
            .catch({ error in
                if let error = error as? OPAPIError {
                    self.attendErrorMsg.send(error.errorDescription ?? "")
                }
                
                return Just(false)
            })
            .sink(receiveCompletion: { event in
                print("completion: postAttendance \(event)")
            }, receiveValue: { result in
                self.attendSuccess.send(result)
            })
            .store(in: cancelBag)
    }
}
