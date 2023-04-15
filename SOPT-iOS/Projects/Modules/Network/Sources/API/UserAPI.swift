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

public enum UserAPI {
    case fetchUser
    case editSentence(sentence: String)
    case getNicknameAvailable(nickname: String)
    case changeNickname(nickname: String)
    case getUserMainInfo
}

extension UserAPI: BaseAPI {
    
    public static var apiType: APIType = .user
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .fetchUser:
            return ""
        case .editSentence:
            return "profile-message"
        case .changeNickname:
            return "nickname"
        case .getNicknameAvailable(let nickname):
            return "nickname/\(nickname)"
        case .getUserMainInfo:
            return "/main"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .fetchUser, .getNicknameAvailable, .getUserMainInfo:
            return .get
        case .editSentence, .changeNickname:
            return .patch
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
}
