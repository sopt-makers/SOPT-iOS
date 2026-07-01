//
//  SoptletterAPI.swift
//  Networks
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Moya

public enum SoptletterAPI {
    case writeMessage(topicId: Int, content: String)
    case fetchProfile
    case completeOnboarding
}

extension SoptletterAPI: BaseAPI {
    public static var apiType: APIType = .soptletter

    public var path: String {
        switch self {
        case .writeMessage(let topicId, _):
            return "/topics/\(topicId)/messages"
        case .fetchProfile:
            return "/onboarding"
        case .completeOnboarding:
            return "/onboarding/complete"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .writeMessage:
            return .post
        case .fetchProfile:
            return .get
        case .completeOnboarding:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .writeMessage(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .completeOnboarding, .fetchProfile:
            return .requestPlain
        }
    }
}
