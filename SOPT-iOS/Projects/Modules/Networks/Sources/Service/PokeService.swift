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
    func getWhoPokedToMe() -> AnyPublisher<PokeUserEntity?, Error>
    func getFriend() -> AnyPublisher<[PokeUserEntity], Error>
    func getFriendRandomUser() -> AnyPublisher<[PokeFriendRandomUserEntity], Error>
}

extension DefaultPokeService: PokeService {
    public func getWhoPokedToMe() -> AnyPublisher<PokeUserEntity?, Error> {
        requestObjectInCombine(.getWhoPokedToMe)
    }
    
    public func getFriend() -> AnyPublisher<[PokeUserEntity], Error> {
        requestObjectInCombine(.getFriend)
    }
    
    public func getFriendRandomUser() -> AnyPublisher<[PokeFriendRandomUserEntity], Error> {
        requestObjectInCombine(.getFriendRandomUser)
    }
}
