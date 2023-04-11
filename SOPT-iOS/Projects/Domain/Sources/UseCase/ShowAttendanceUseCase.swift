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

}

public class DefaultShowAttendanceUseCase {
  
    private let repository: ShowAttendanceRepositoryInterface
    private var cancelBag = CancelBag()
  
    public init(repository: ShowAttendanceRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultShowAttendanceUseCase: ShowAttendanceUseCase {
  
}
