//
//  RankAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum RankAPI {
    case rank(userId: Int)
    case editSentence(userId: Int, sentence: String)
}

extension RankAPI: BaseAPI {
    
    public static var apiType: APIType = .rank
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .rank(let userId), .editSentence(let userId, _):
            return HeaderType.userId(userId: userId).value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .rank:
            return ""
        case .editSentence:
            return "/profileMessage"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .editSentence:
            return .post
        default: return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .editSentence(_, let sentence):
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
        case .editSentence:
            return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
