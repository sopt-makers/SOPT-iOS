//
//  ReissueAPI.swift
//  Networks
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

import Alamofire
import Moya

//MARK: - ReissueAPI
public enum ReissueAPI {
    case reissue(AuthTokens)
}

extension ReissueAPI: BaseAPI {
    public static var apiType: APIType = .coreAuth
    
    public var path: String { "/refresh/app"}
    
    public var method: Moya.Method { .post }
    
    public var task: Moya.Task {
        switch self {
        case .reissue(let token):
                .requestParameters(parameters: [
                    "accessToken": "Bearer " + token.accessToken,
                    "refreshToken": token.refreshToken
                ], encoding: JSONEncoding.default)
        }
    }
}
