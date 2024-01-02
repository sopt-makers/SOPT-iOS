//
//  PokeMainRepositoryInterface.swift
//  Domain
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeMainRepositoryInterface: PokeRepositoryInterface {
    func getWhoPokeToMe() -> AnyPublisher<PokeUserModel?, Error>
    func getFriend() -> AnyPublisher<[PokeUserModel], Error>
    func getFriendRandomUser() -> AnyPublisher<[PokeFriendRandomUserModel], Error>
    func checkPokeNewUser() -> AnyPublisher<Bool, Error>
}
