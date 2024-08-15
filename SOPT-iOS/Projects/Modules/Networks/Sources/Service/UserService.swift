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
import Core

public typealias DefaultUserService = BaseService<UserAPI>

public protocol UserService {
    func fetchSoptampUser() -> AnyPublisher<SoptampUserEntity, Error>
    func editSentence(sentence: String) -> AnyPublisher<EditSentenceEntity, Error>
    func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error>
    func changeNickname(nickname: String) -> AnyPublisher<Int, Error>
    func getUserMainInfo() -> AnyPublisher<MainEntity, Error>
    func withdraw() -> AnyPublisher<Int, Error>
    func registerPushToken(with token: String) -> AnyPublisher<Int, Error>
    func deregisterPushToken(with token: String) -> AnyPublisher<Int, Error>
    func fetchActiveGenerationStatus() -> AnyPublisher<UsersActiveGenerationStatusEntity, Error>
    func getNotificationIsAllowed() -> AnyPublisher<GeneralNotificationOptInEntity, Error>
    func optInPushNotificationInGeneral(to isOn: Bool) -> AnyPublisher<GeneralNotificationOptInEntity, Error>
    func getNotificationSettingsInDetail() -> AnyPublisher<DetailNotificationOptInEntity, Error>
    func optInPushNotificationInDetail(notificationSettings: DetailNotificationOptInEntity) -> AnyPublisher<DetailNotificationOptInEntity, Error>
    func appService() -> AnyPublisher<[AppServiceEntity], Error>
    func hotBoard() -> AnyPublisher<HotBoardEntity, Error>
}

extension DefaultUserService: UserService {
    public func fetchSoptampUser() -> AnyPublisher<SoptampUserEntity, Error> {
        requestObjectInCombine(.fetchSoptampUser)
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
        requestObjectWithNetworkErrorInCombine(.getUserMainInfo)
    }
    
    public func withdraw() -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.withdrawal)
    }
    
    public func registerPushToken(with token: String) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.registerPushToken(token: token))
    }
    
    public func deregisterPushToken(with token: String) -> AnyPublisher<Int, Error> {
        requestObjectInCombineNoResult(.deregisterPushToken(token: token))
    }
    
    public func fetchNotificationSettings() -> AnyPublisher<DetailNotificationOptInEntity, Error> {
        requestObjectInCombine(.getNotificationSettingsInDetail)
    }
    
    public func fetchActiveGenerationStatus() -> AnyPublisher<UsersActiveGenerationStatusEntity, Error> {
        requestObjectInCombine(.fetchActiveGenerationStatus)
    }

    public func getNotificationIsAllowed() -> AnyPublisher<GeneralNotificationOptInEntity, Error> {
        requestObjectInCombine(.getNotificationIsAllowed)
    }
    
    public func optInPushNotificationInGeneral(to isOn: Bool) -> AnyPublisher<GeneralNotificationOptInEntity, Error> {
        requestObjectInCombine(.optInPushNotificationInGeneral(isOn: isOn))
    }
    
    public func getNotificationSettingsInDetail() -> AnyPublisher<DetailNotificationOptInEntity, Error> {
        requestObjectInCombine(.getNotificationSettingsInDetail)
    }

    public func optInPushNotificationInDetail(notificationSettings: DetailNotificationOptInEntity) -> AnyPublisher<DetailNotificationOptInEntity, Error> {
        requestObjectInCombine(.optInPushNotificationInDetail(notificationSettings: notificationSettings))
    }

    public func appService() -> AnyPublisher<[AppServiceEntity], Error> {
        requestObjectWithNetworkErrorInCombine(.appService)
    }

    public func hotBoard() -> AnyPublisher<HotBoardEntity, Error> {
        requestObjectWithNetworkErrorInCombine(.hotboard)
    }
}
