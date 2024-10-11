//
//  AppMyPageRepositoryInterface.swift
//  Domain
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol AppMyPageRepositoryInterface {
    func resetStamp() -> Driver<Bool>
    func deregisterPushToken(with token: String) -> AnyPublisher<Bool, Error>
}
