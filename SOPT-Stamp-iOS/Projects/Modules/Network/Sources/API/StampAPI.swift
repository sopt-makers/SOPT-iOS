//
//  StampAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum StampAPI {
    case fetchStampListDetail(userId: Int, missionId: Int)
}

extension StampAPI: BaseAPI {
    
    public static var apiType: APIType = .stamp
    
    // MARK: - Header
    public var headers: [String : String]? {
        switch self {
        case .fetchStampListDetail(let userId, _):
            return HeaderType.userId(userId: userId).value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .fetchStampListDetail(_, let missionId):
            return "/\(missionId)"
        default: return ""
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
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
        default:
            return .requestPlain
        }
    }
}
