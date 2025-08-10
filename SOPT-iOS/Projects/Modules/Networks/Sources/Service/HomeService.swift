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
    func getAppServiceAccessStatus() -> AnyPublisher<[HomeAppServiceAccessStatusEntity], Error>
    func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonResponseEntity, Error>
    
    /// async
    func getDescriptionAsync() async throws -> HomeDescriptionEntity
    func getAppServiceAccessStatusAsync() async throws -> [HomeAppServiceAccessStatusEntity]
    func getSurveyInfoAsync() async throws -> HomeSurveyResponseEntity
    func getPopularPostsAsync() async throws -> [HomePopularPostsResponseEntity]
    func getLatestPostsAsync() async throws -> [HomeLatestPostsResponseEntity]
}

extension DefaultHomeService: HomeService {
    public func getAppServiceAccessStatus() -> AnyPublisher<[HomeAppServiceAccessStatusEntity], any Error> {
        requestObjectInCombine(.getAppServiceAccessStatus)
    }
    
    public func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonResponseEntity, any Error> {
        requestObjectInCombine(.getFABInfo)
    }

    public func getDescriptionAsync() async throws -> HomeDescriptionEntity {
        try await requestObjectAsync(.getDescription)
    }
    
    public func getAppServiceAccessStatusAsync() async throws -> [HomeAppServiceAccessStatusEntity] {
        try await requestObjectAsync(.getAppServiceAccessStatus)
    }

    public func getSurveyInfoAsync() async throws -> HomeSurveyResponseEntity {
        try await requestObjectAsync(.getSurveyInfo)
    }
    
    public func getPopularPostsAsync() async throws -> [HomePopularPostsResponseEntity] {
        let response: HomePopularPostsResponseEntityWrapper = try await requestObjectAsync(.getPopularPosts)
        return response.popularPosts
    }
    
    public func getLatestPostsAsync() async throws -> [HomeLatestPostsResponseEntity] {
        let response: HomeLatestPostsResponseEntityWrapper = try await requestObjectAsync(.getLatestPosts)
        return response.recentPosts
    }
}
