//
//  NotificationAPI.swift
//  Network
//
//  Created by sejin on 2023/09/09.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum NotificationAPI {
    case getNotificationList(page: Int)
    case readNotification(notificationId: Int)
}

extension NotificationAPI: BaseAPI {
    public static var apiType: APIType = .notification
    
    public var path: String {
        switch self {
        case .readNotification(let notificationId):
            return "/\(notificationId)"
        default:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .readNotification:
            return .patch
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getNotificationList(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
