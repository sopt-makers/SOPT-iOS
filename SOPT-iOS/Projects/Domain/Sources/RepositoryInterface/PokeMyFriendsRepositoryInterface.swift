//
//  PokeMyFriendsRepositoryInterface.swift
//  Domain
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeMyFriendsRepositoryInterface: PokeRepositoryInterface {
    func getFriends() -> AnyPublisher<PokeMyFriendsModel, Error>
    func getFriends(relation: String, page: Int) -> AnyPublisher<PokeMyFriendsListModel, Error>
}
