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
    case fetchTopics
    case fetchTopic(topicId: Int)
}

extension SoptletterAPI: BaseAPI {
    public static var apiType: APIType = .soptletter

    public var path: String {
        switch self {
        case .writeMessage(let topicId, _):
            return "/topics/\(topicId)/messages"
        case .fetchTopics:
            return "/topics"
        case .fetchTopic(let topicId):
            return "/topics/\(topicId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .writeMessage:
            return .post
        case .fetchTopics, .fetchTopic:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .writeMessage(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .fetchTopics:
            return .requestPlain
        case .fetchTopic:
            return .requestPlain
        }
    }
}
