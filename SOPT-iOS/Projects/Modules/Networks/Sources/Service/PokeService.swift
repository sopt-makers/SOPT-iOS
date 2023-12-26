//
//  PokeService.swift
//  Networks
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya
import Domain

public typealias DefaultPokeService = BaseService<PokeAPI>

public protocol PokeService {
    func getWhoPokedToMe() -> AnyPublisher<PokeUserEntity?, Error>
    func getWhoPokedToMeList(pageIndex: String)  -> AnyPublisher<PokedToMeHistoryListEntity, Error>
    func getFriend() -> AnyPublisher<[PokeUserEntity], Error>
    func getFriendRandomUser() -> AnyPublisher<[PokeFriendRandomUserEntity], Error>
    func getFriendList() -> AnyPublisher<PokeMyFriendsEntity, Error>
    func getFriendList(relation: String, page: Int) -> AnyPublisher<PokeMyFriendsListEntity, Error>
    func getRandomUsers() -> AnyPublisher<[PokeUserEntity], Error>
    func getPokeMessages(messageType: String) -> AnyPublisher<PokeMessagesEntity, Error>
    func poke(userId: Int, message: String) -> AnyPublisher<PokeUserEntity, PokeError>
}

extension DefaultPokeService: PokeService {
    public func getWhoPokedToMe() -> AnyPublisher<PokeUserEntity?, Error> {
        requestObjectInCombine(.getWhoPokedToMe)
    }
    
    public func getWhoPokedToMeList(pageIndex: String) -> AnyPublisher<PokedToMeHistoryListEntity, Error> {
        requestObjectInCombine(.getWhoPokedToMeList(pageIndex: pageIndex))
    }
    
    public func getFriend() -> AnyPublisher<[PokeUserEntity], Error> {
        requestObjectInCombine(.getFriend)
    }
    
    public func getFriendList(relation: String, page: Int) -> AnyPublisher<PokeMyFriendsListEntity, Error> {
        requestObjectInCombine(.getFriendListWithRelation(relation: relation, page: page))
    }
    
    public func getFriendRandomUser() -> AnyPublisher<[PokeFriendRandomUserEntity], Error> {
        requestObjectInCombine(.getFriendRandomUser)
    }
    
    public func getFriendList() -> AnyPublisher<PokeMyFriendsEntity, Error> {
        requestObjectInCombine(.getFriendList)
    }
    
    public func getRandomUsers() -> AnyPublisher<[PokeUserEntity], Error> {
        requestObjectInCombine(.getRandomUsers)
    }
    
    public func getPokeMessages(messageType: String) -> AnyPublisher<PokeMessagesEntity, Error> {
        requestObjectInCombine(.getPokeMessages(messageType: messageType))
    }
    
    public func poke(userId: Int, message: String) -> AnyPublisher<PokeUserEntity, PokeError> {
        let params: [String: Any] = ["message": message]
        
        return requestObjectWithNetworkErrorInCombine(.poke(userId: String(describing: userId), params: params))
            .mapError { error in
                guard let apiError = error as? APIError else {
                    return PokeError.networkError
                }
                
                switch apiError {
                case .network(let statusCode, let response):
                    if statusCode == 400 {
                        return PokeError.exceedTodayPokeCount(message: response.responseMessage)
                    }
                    
                    return PokeError.unknown(message: response.responseMessage)
                default:
                    return PokeError.networkError
                }
            }.eraseToAnyPublisher()
    }
}
