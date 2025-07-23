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
    func getPlaygroundNewsPosts() -> AnyPublisher<[HomePlaygroundNewsPostsResponseEntity], Error>
    func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonResponseEntity, Error>
    func getSurveyInfo() -> AnyPublisher<HomeSurveyResponseEntity, Error>
    
    /// async
    func getDescriptionAsync() async throws -> HomeDescriptionEntity
    func getAppServiceAccessStatusAsync() async throws -> [HomeAppServiceAccessStatusEntity]
    func getPlaygroundNewsPostsAsync() async throws -> [HomePlaygroundNewsPostsResponseEntity]
    func getSurveyInfoAsync() async throws -> HomeSurveyResponseEntity
    func getPopularPostsAsync() async throws -> [HomePopularPostsResponseEntity]
    func getLatestPostsAsync() async throws -> [HomeLatestPostsResponseEntity]
}

extension DefaultHomeService: HomeService {
    public func getDescription() -> AnyPublisher<HomeDescriptionEntity, any Error> {
        requestObjectInCombine(.getDescription)
    }
    
    public func getAppServiceAccessStatus() -> AnyPublisher<[HomeAppServiceAccessStatusEntity], any Error> {
        requestObjectInCombine(.getAppServiceAccessStatus)
    }
    
    public func getPlaygroundNewsPosts() -> AnyPublisher<[HomePlaygroundNewsPostsResponseEntity], any Error> {
        requestObjectInCombine(.getPlaygroundNewsPosts)
    }
    
    public func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonResponseEntity, any Error> {
        requestObjectInCombine(.getFABInfo)
    }
    
    public func getSurveyInfo() -> AnyPublisher<HomeSurveyResponseEntity, any Error> {
        requestObjectInCombine(.getSurveyInfo)
    }
    
    public func getDescriptionAsync() async throws -> HomeDescriptionEntity {
        try await requestObjectAsync(.getDescription)
    }
    
    public func getAppServiceAccessStatusAsync() async throws -> [HomeAppServiceAccessStatusEntity] {
        try await requestObjectAsync(.getAppServiceAccessStatus)
    }
    
    public func getPlaygroundNewsPostsAsync() async throws -> [HomePlaygroundNewsPostsResponseEntity] {
        try await requestObjectAsync(.getPlaygroundNewsPosts)
    }
    
    public func getSurveyInfoAsync() async throws -> HomeSurveyResponseEntity {
        try await requestObjectAsync(.getSurveyInfo)
    }
    
    public func getPopularPostsAsync() async throws -> [HomePopularPostsResponseEntity] {
        try await requestObjectAsync(.getPopularPosts)
    }
    
    public func getLatestPostsAsync() async throws -> [HomeLatestPostsResponseEntity] {
        try await requestObjectAsync(.getLatestPosts)
    }
}
