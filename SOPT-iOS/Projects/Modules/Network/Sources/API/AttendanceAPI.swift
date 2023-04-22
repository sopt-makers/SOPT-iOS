//
//  AttendanceAPI.swift
//  Network
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum AttendanceAPI {
    case lecture
    case score
    case total
    case lectureRound(lectureId: Int)
    case attend(lectureRoundId: Int, code: String)
}

extension AttendanceAPI: BaseAPI {
    
    public static var apiType: APIType = .attendance
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .lecture, .score, .total, .lectureRound, .attend:
            return HeaderType.jsonWithToken.value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .lecture:
            return "lecture"
        case .score:
            return "members/score"
        case .total:
            return "total"
        case .lectureRound(let lectureId):
            return "lectures/round/\(lectureId)"
        case .attend:
            return "attendances/attend"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .lecture, .score, .total, .lectureRound:
            return .get
        case .attend:
            return .post
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        
        switch self {
        case let .attend(lectureRoundId: id, code: code):
            params["subLectureId"] = id
            params["code"] = code
        default:
            break
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
        case .attend:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
