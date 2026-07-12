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
    case fetchProfile
    case completeOnboarding
    case soptletterMessages(topicId: Int, cursor: Int?, size: Int?)
    case soptletterMessage(messageId: Int, topicId: Int)
    case editMessage(messageId: Int, topicId: Int, content: String)
    case deleteMessage(messageId: Int, topicId: Int)
    case likeMessage(messageId: Int, topicId: Int)
    case unlikeMessage(messageId: Int, topicId: Int)
}

extension SoptletterAPI: BaseAPI {
    public static var apiType: APIType = .soptletter
    
    public var path: String {
        switch self {
        case .writeMessage(let topicId, _), .soptletterMessages(let topicId, _, _):
            return "/topics/\(topicId)/messages"
        case .fetchTopics:
            return "/topics"
        case .fetchTopic(let topicId):
            return "/topics/\(topicId)"
        case .fetchProfile:
            return "/onboarding"
        case .completeOnboarding:
            return "/onboarding/complete"
        case let .soptletterMessage(messageId, topicId), let .deleteMessage(messageId, topicId), let .editMessage(messageId, topicId, _):
            return "/topics/\(topicId)/messages/\(messageId)"
        case let .likeMessage(messageId, topicId), let .unlikeMessage(messageId, topicId):
            return "/topics/\(topicId)/messages/\(messageId)/likes"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .writeMessage, .completeOnboarding, .likeMessage:
            return .post
        case .fetchTopics, .fetchTopic, .fetchProfile, .soptletterMessages, .soptletterMessage:
            return .get
        case .editMessage:
            return .patch
        case .deleteMessage, .unlikeMessage:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .writeMessage(_, let content):
                return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case let .editMessage(_, _, content):
                return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
        case .fetchTopics, .fetchTopic, .completeOnboarding, .fetchProfile, .soptletterMessages, .soptletterMessage, .deleteMessage, .likeMessage, .unlikeMessage:
                return .requestPlain   
        }
    }
}
