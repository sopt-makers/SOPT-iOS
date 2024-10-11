//
//  UserAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum UserAPI {
    case fetchSoptampUser
    case editSentence(sentence: String)
    case getNicknameAvailable(nickname: String)
    case changeNickname(nickname: String)
    case getUserMainInfo
    case withdrawal
    case registerPushToken(token: String)
    case deregisterPushToken(token: String)
    case fetchActiveGenerationStatus
    case optInPushNotificationInGeneral(isOn: Bool)
    case getNotificationSettingsInDetail
    case optInPushNotificationInDetail(notificationSettings: DetailNotificationOptInEntity)
    case appService
    case hotboard
}

extension UserAPI: BaseAPI {
    
    public static var apiType: APIType = .user
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .fetchSoptampUser:
            return "soptamp"
        case .editSentence:
            return "profile-message"
        case .changeNickname:
            return "nickname"
        case .getNicknameAvailable(let nickname):
            return "nickname/\(nickname)"
        case .getUserMainInfo:
            return "/main"
        case .withdrawal:
            return ""
        case .registerPushToken, .deregisterPushToken:
            return "/push-token"
        case .fetchActiveGenerationStatus:
            return "/generation"
        case .optInPushNotificationInGeneral:
            return "/opt-in"
        case .getNotificationSettingsInDetail:
            return "/opt-in/detail"
        case .optInPushNotificationInDetail:
            return "/opt-in/detail"
        case .appService:
            return "app-service"
        case .hotboard:
            return "playground/hot-post"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getNicknameAvailable, .getUserMainInfo, .fetchSoptampUser, .fetchActiveGenerationStatus, .getNotificationSettingsInDetail, .appService, .hotboard:
            return .get
        case .editSentence, .changeNickname, .optInPushNotificationInGeneral, .optInPushNotificationInDetail:
            return .patch
        case .withdrawal:
            return .delete
        case .registerPushToken:
           return .post
        case .deregisterPushToken:
            return .delete
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .changeNickname(let nickname):
            params["nickname"] = nickname
        case .editSentence(let sentence):
            params["profileMessage"] = sentence
        case .registerPushToken(let pushToken):
            params["platform"] = "iOS"
            params["pushToken"] = pushToken
        case .deregisterPushToken(let pushToken):
            params["platform"] = "iOS"
            params["pushToken"] = pushToken
        case .optInPushNotificationInGeneral(let isOn):
            params["isOptIn"] = isOn
        case .optInPushNotificationInDetail(let optInDTO):
            params = optInDTO.toDictionary()
        default: break
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .changeNickname, .editSentence, .registerPushToken,
                .optInPushNotificationInGeneral, .optInPushNotificationInDetail, .deregisterPushToken:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
    
    public var validationType: ValidationType {
        switch self {
        default : return .successCodes
        }
    }
}
