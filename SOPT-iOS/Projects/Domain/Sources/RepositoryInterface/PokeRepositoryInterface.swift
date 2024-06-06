//
//  PokeRepositoryInterface.swift
//  Domain
//
//  Created by sejin on 12/24/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeRepositoryInterface {
    func poke(userId: Int, message: String, isAnonymous: Bool) -> AnyPublisher<PokeUserModel, PokeError>
}
