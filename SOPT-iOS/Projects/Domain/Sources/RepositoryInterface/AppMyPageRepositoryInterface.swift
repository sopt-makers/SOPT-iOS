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
    func editSoptampSentence(sentence: String) -> AnyPublisher<Bool, Never>
    func editSoptampNickname(nickname: String) -> AnyPublisher<Bool, Never>
    func withdrawalStamp() -> AnyPublisher<Bool, Never>
//    func logout() -> AnyPublisher<Bool, Never>
}
