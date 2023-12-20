//
//  PokeMainRepositoryInterface.swift
//  Domain
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol PokeMainRepositoryInterface {
    func getWhoPokeToMe() -> AnyPublisher<PokeUserModel?, Error>
}
