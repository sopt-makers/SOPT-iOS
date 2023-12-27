//
//  PokeNotificationRepositoryInterface.swift
//  Domain
//
//  Created by Ian on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeNotificationRepositoryInterface: PokeRepositoryInterface {
    func getWhoPokedMeList(page: Int) -> AnyPublisher<(users: [PokeUserModel], page: Int), Error>
}
