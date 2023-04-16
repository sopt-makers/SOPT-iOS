//
//  AppMyPageRepository.swift
//  Data
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network
 
public final class AppMyPageRepository {
    private let stampService: StampService

    public init(stampService: StampService) {
        self.stampService = stampService
    }
}

extension AppMyPageRepository: AppMyPageRepositoryInterface {
    public func resetStamp() -> Driver<Bool> {
        stampService
            .resetStamp()
            .map { $0 == 200 }
            .asDriver()
    }
}
