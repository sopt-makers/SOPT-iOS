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
    func getAppServiceAccessStatus() -> AnyPublisher<[HomeAppServiceAccessStatusEntity], Error>
    func getInsightPosts() -> AnyPublisher<[HomeInsightPostsEntity], Error>
    func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonResponseEntity, Error>
}

extension DefaultHomeService: HomeService {
    public func getDescription() -> AnyPublisher<HomeDescriptionEntity, any Error> {
        requestObjectInCombine(.getDescription)
    }
    
    public func getAppServiceAccessStatus() -> AnyPublisher<[HomeAppServiceAccessStatusEntity], any Error> {
        requestObjectInCombine(.getAppServiceAccessStatus)
    }
    
    public func getInsightPosts() -> AnyPublisher<[HomeInsightPostsEntity], any Error> {
        requestObjectInCombine(.getInsightPosts)
    }
    
    public func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonResponseEntity, any Error> {
        requestObjectInCombine(.getFABInfo)
    }
}
