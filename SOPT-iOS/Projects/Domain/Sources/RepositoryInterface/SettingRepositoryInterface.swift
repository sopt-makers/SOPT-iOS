//
//  SettingRepositoryInterface.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/17.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Core

import Combine

public protocol SettingRepositoryInterface {
    func resetStamp() -> Driver<Bool>
    func editSentence(sentence: String) -> AnyPublisher<Bool, Never>
    func withdrawal() -> AnyPublisher<Bool, Never>
}
