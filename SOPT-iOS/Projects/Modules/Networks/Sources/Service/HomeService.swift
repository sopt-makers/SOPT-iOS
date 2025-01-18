//
//  HomeService.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya

public typealias DefaultHomeService = BaseService<HomeAPI>

public protocol HomeService {
    func getDescription() -> AnyPublisher<HomeDescriptionEntity, Error>
    func getGroupAll() -> AnyPublisher<[HomeGroupEntity], Error>
    func getCoffeeChat() -> AnyPublisher<[HomeCoffeeChatEntity], Error>
}

extension DefaultHomeService: HomeService {
    public func getDescription() -> AnyPublisher<HomeDescriptionEntity, any Error> {
        requestObjectInCombine(.getDescription)
    }
    
    public func getGroupAll() -> AnyPublisher<[HomeGroupEntity], any Error> {
        requestObjectInCombine(.getGroupAll)
    }
    
    public func getCoffeeChat() -> AnyPublisher<[HomeCoffeeChatEntity], any Error> {
        requestObjectInCombine(.getCoffeeChat)
    }
}
