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
    case getUserMainInfo
    case withdrawal
    case registerPushToken(token: String)
    case deregisterPushToken(token: String)
    case fetchActiveGenerationStatus
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
        case .getUserMainInfo:
            return "/main"
        case .withdrawal:
            return ""
        case .registerPushToken, .deregisterPushToken:
            return "/push-token"
        case .fetchActiveGenerationStatus:
            return "/generation"
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
        case .getUserMainInfo, .fetchSoptampUser, .fetchActiveGenerationStatus, .getNotificationSettingsInDetail, .appService, .hotboard:
            return .get
        case .editSentence, .optInPushNotificationInDetail:
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
        case .editSentence(let sentence):
            params["profileMessage"] = sentence
        case .registerPushToken(let pushToken):
            params["platform"] = "iOS"
            params["pushToken"] = pushToken
        case .deregisterPushToken(let pushToken):
            params["platform"] = "iOS"
            params["pushToken"] = pushToken
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
        case .editSentence, .registerPushToken, .optInPushNotificationInDetail, .deregisterPushToken:
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
