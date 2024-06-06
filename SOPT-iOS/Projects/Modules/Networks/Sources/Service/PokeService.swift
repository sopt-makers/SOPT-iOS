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

public typealias DefaultPokeService = BaseService<PokeAPI>

public protocol PokeService {
  func isNewUser() -> AnyPublisher<PokeIsNewUserEntity, Error>
  func getWhoPokedToMe() -> AnyPublisher<PokeUserEntity?, Error>
  func getWhoPokedToMeList(pageIndex: String)  -> AnyPublisher<PokedToMeHistoryListEntity, Error>
  func getFriend() -> AnyPublisher<[PokeUserEntity], Error>
  func getFriendRandomUser(randomType: String, size: Int) -> AnyPublisher<PokeFriendRandomUserEntity, Error>
  func getFriendList() -> AnyPublisher<PokeMyFriendsEntity, Error>
  func getFriendList(relation: String, page: Int) -> AnyPublisher<PokeMyFriendsListEntity, Error>
  func getRandomUsers(randomType: String, size: Int) -> AnyPublisher<PokeRandomListEntity, Error>
  func getPokeMessages(messageType: String) -> AnyPublisher<PokeMessagesEntity, Error>
  func poke(userId: Int, message: String, isAnonymous: Bool) -> AnyPublisher<PokeUserEntity, Error>
}

extension DefaultPokeService: PokeService {
  public func isNewUser() -> AnyPublisher<PokeIsNewUserEntity, Error> {
    requestObjectInCombine(.isNewUser)
  }
  
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
  
  public func getFriendRandomUser(randomType: String, size: Int) -> AnyPublisher<PokeFriendRandomUserEntity, Error> {
    let params: [String: Any] = [
      "randomType": randomType,
      "size": size
    ]
    
    return requestObjectInCombine(.getFriendRandomUser(params: params))
  }
  
  public func getFriendList() -> AnyPublisher<PokeMyFriendsEntity, Error> {
    requestObjectInCombine(.getFriendList)
  }
  
  public func getRandomUsers(randomType: String, size: Int) -> AnyPublisher<PokeRandomListEntity, Error> {
    let params: [String: Any] = [
      "randomType": randomType,
      "size": size
    ]

    return requestObjectInCombine(.getRandomUsers(params: params))
  }
  
  public func getPokeMessages(messageType: String) -> AnyPublisher<PokeMessagesEntity, Error> {
    requestObjectInCombine(.getPokeMessages(messageType: messageType))
  }
  
  public func poke(userId: Int, message: String, isAnonymous: Bool) -> AnyPublisher<PokeUserEntity, Error> {
    let params: [String: Any] = [
      "message": message,
      "isAnonymous": isAnonymous
    ]
    
    return requestObjectWithNetworkErrorInCombine(.poke(userId: String(describing: userId), params: params))
  }
}
