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
    case soptletterMessages(topicId: Int, cursor: Int?, size: Int?)
    case soptletterMessage(messageId: Int, topicId: Int)
    case editMessage(messageId: Int, topicId: Int, content: String)
    case deleteMessage(messageId: Int, topicId: Int)
}

extension SoptletterAPI: BaseAPI {
    public static var apiType: APIType = .soptletter

    public var path: String {
        switch self {
        case .writeMessage(let topicId, _), .soptletterMessages(let topicId, _, _):
            return "/topics/\(topicId)/messages"
        case let .soptletterMessage(messageId, topicId):
            return "/topics/\(topicId)/messages/\(messageId)"
        case let .editMessage(messageId, topicId, _):
            return "/topics/\(topicId)/messages/\(messageId)"
        case let .deleteMessage(messageId, topicId):
            return "/topics/\(topicId)/messages/\(messageId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .writeMessage:
            return .post
        case .editMessage:
            return .patch
        case .soptletterMessages, .soptletterMessage:
            return .get
        case .deleteMessage:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case .writeMessage(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .soptletterMessages:
            return .requestPlain
        case .soptletterMessage:
            return .requestPlain
        case let .editMessage(_, _, content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .deleteMessage:
            return .requestPlain
        }
    }
}
