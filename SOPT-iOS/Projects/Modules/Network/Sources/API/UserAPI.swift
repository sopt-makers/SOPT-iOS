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
    case fetchActiveGenerationStatus
    case optInPushNotification(notificationSettings: NotificationOptInEntity)
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
        case .registerPushToken:
            return "/push-token"
        case .fetchActiveGenerationStatus:
            return "/generation"
        case .optInPushNotification:
            return "/opt-in"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getNicknameAvailable, .getUserMainInfo, .fetchSoptampUser, .fetchActiveGenerationStatus:
            return .get
        case .editSentence, .changeNickname, .optInPushNotification:
            return .patch
        case .withdrawal:
            return .delete
        case .registerPushToken:
           return .post
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
            params["pushToken"] = pushToken
        case .optInPushNotification(let optInDTO):
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
        case .changeNickname, .editSentence, .registerPushToken, .optInPushNotification:
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
