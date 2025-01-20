//
//  HomeRepository.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class HomeRepository {
    
    private let homeService: HomeService
    private let calendarService: CalendarService
    
    private let cancelBag = CancelBag()
    
    public init(homeService: HomeService,
                calendarService: CalendarService
    ) {
        self.homeService = homeService
        self.calendarService = calendarService
    }
}

extension HomeRepository: HomeRepositoryInterface {
    public func getAppServices() -> AnyPublisher<[Domain.HomeAppServicesModel], any Error> {
        homeService.getAppServiceAccessStatus()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getInsightPosts() -> AnyPublisher<[Domain.HomeInsightPostsModel], any Error> {
        homeService.getInsightPosts()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getHomeDescription() -> AnyPublisher<Domain.HomeDescriptionModel, any Error> {
        homeService.getDescription()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getRecentSchedule() -> AnyPublisher<Domain.HomeRecentScheduleModel, any Error> {
        calendarService.getRecentSchedule()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getGroupPosts() -> AnyPublisher<[Domain.HomeGroupPostModel], any Error> {
        homeService.getGroupAll()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getCoffeeChatPosts() -> AnyPublisher<[Domain.HomeCoffeeChatPostModel], any Error> {
        homeService.getCoffeeChat()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getAnnouncementPosts() -> AnyPublisher<[Domain.HomeAnnouncementModel], any Error> {
        homeService.getHomeEmploymentEntity()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
