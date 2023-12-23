//
//  PokeOnboardingRepositoryInterface.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeOnboardingRepositoryInterface {
    func getRandomAcquaintances() -> AnyPublisher<[PokeUserModel], Error>
    func getMesseageTemplates() -> AnyPublisher<[PokeMessageModel], Error>
    func poke(userId: Int, message: String) -> AnyPublisher<PokeUserModel, Error>
}
