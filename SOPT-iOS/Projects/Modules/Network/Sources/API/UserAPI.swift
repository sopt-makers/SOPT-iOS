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
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getNicknameAvailable, .getUserMainInfo, .fetchSoptampUser:
            return .get
        case .editSentence, .changeNickname:
            return .patch
        case .withdrawal:
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
        case .changeNickname, .editSentence:
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
