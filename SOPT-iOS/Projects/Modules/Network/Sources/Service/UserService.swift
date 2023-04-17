//
//  UserService.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultUserService = BaseService<UserAPI>

public protocol UserService {
    // TODO: - UserEntity 관련 변경사항 적용하기
    func fetchUser() -> AnyPublisher<SignInEntity, Error>
    
    func editSentence(sentence: String) -> AnyPublisher<EditSentenceEntity, Error>
    func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error>
    func changeNickname(nickname: String) -> AnyPublisher<Int, Error>
    func getUserMainInfo() -> AnyPublisher<MainEntity, Error>
    func withdrawal() -> AnyPublisher<Int, Error>
}

extension DefaultUserService: UserService {
    public func fetchUser() -> AnyPublisher<SignInEntity, Error> {
        requestObjectInCombine(.fetchUser)
    }
    
    public func editSentence(sentence: String) -> AnyPublisher<EditSentenceEntity, Error> {
        requestObjectInCombine(.editSentence(sentence: sentence))
    }
    
    public func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.getNicknameAvailable(nickname: nickname))
    }
    
    public func changeNickname(nickname: String) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.changeNickname(nickname: nickname))
    }
    
    public func getUserMainInfo() -> AnyPublisher<MainEntity, Error> {
        requestObjectInCombine(.getUserMainInfo)
    }
    
    public func withdrawal() -> AnyPublisher<Int, Error> {
        return requestObjectInCombineNoResult(.withdrawal)
    }
}
