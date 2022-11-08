//
//  NoticeAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/10/16.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import UIKit

import Alamofire
import Moya

public enum NoticeAPI {
    case fetchNotcieDetail(noticeId: Int)
}

extension NoticeAPI: BaseAPI {
    
    public static var apiType: APIType = .notice
    
    // MARK: - Path
    public var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .fetchNotcieDetail(let noticeId):
            params["notice_id"] = noticeId
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchNotcieDetail:
            return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
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
