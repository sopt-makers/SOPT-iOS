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
<<<<<<< HEAD
    case fetchProfile
    case completeOnboarding
=======
    case soptletterMessages(topicId: Int, cursor: Int?, size: Int?)
    case soptletterMessage(messageId: Int, topicId: Int)
>>>>>>> develop
}

extension SoptletterAPI: BaseAPI {
    public static var apiType: APIType = .soptletter

    public var path: String {
        switch self {
        case .writeMessage(let topicId, _), .soptletterMessages(let topicId, _, _):
            return "/topics/\(topicId)/messages"
<<<<<<< HEAD
        case .fetchProfile:
            return "/onboarding"
        case .completeOnboarding:
            return "/onboarding/complete"
=======
        case let .soptletterMessage(messageId, topicId):
            return "/topics/\(topicId)/messages/\(messageId)"
>>>>>>> develop
        }
    }

    public var method: Moya.Method {
        switch self {
        case .writeMessage:
            return .post
<<<<<<< HEAD
        case .fetchProfile:
            return .get
        case .completeOnboarding:
            return .post
=======
        case .soptletterMessages, .soptletterMessage:
            return .get
>>>>>>> develop
        }
    }

    public var task: Moya.Task {
        switch self {
        case .writeMessage(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
<<<<<<< HEAD
        case .completeOnboarding, .fetchProfile:
=======
        case .soptletterMessages(topicId: let topicId, cursor: let cursor, size: let size):
            return .requestPlain
        case .soptletterMessage:
>>>>>>> develop
            return .requestPlain
        }
    }
}
