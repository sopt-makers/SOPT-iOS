//
//  PokeAPI.swift
//  Networks
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum PokeAPI {
    case getWhoPokedToMe
    case getWhoPokedToMeList(pageIndex: String)
    case getFriend
    case getFriendRandomUser
    case getFriendList
    case getRandomUsers
    case getPokeMessages(messageType: PokeMessageType)
    case poke(userId: String, params: Parameters)
}

extension PokeAPI: BaseAPI {
    public static var apiType: APIType = .poke
    
    public var path: String {
        switch self {
        case .getWhoPokedToMe:
            return "/to/me"
        case .getWhoPokedToMeList:
            return "/to/me/list"
        case .getFriend:
            return "/friend"
        case .getFriendRandomUser:
            return "/friend/random-user"
        case .getFriendList:
            return "/friend/list"
        case .getRandomUsers:
            return "/random-user"
        case .getPokeMessages:
            return "/message"
        case .poke(let userId, _):
            return "/\(userId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getWhoPokedToMe, .getWhoPokedToMeList, .getFriend, .getFriendRandomUser,
                .getFriendList, .getRandomUsers, .getPokeMessages:
            return .get
        case .poke:
            return .put
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getWhoPokedToMeList(let pageIndex):
            return .requestParameters(parameters: ["page": pageIndex], encoding: URLEncoding.queryString)
        case .getPokeMessages(let messageType):
            return .requestParameters(parameters: ["messageType": messageType.rawValue], encoding: URLEncoding.queryString)
        case .poke(_, let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
}
