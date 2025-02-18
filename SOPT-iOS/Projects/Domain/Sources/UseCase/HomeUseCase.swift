//
//  HomeUseCase.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol HomeUseCase {
    func getHomeDescription() -> AnyPublisher<HomeDescriptionModel, Never>
    func getUserInfo() -> AnyPublisher<UserMainInfoModel?, Never>
    func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Never>
    func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Never>
    func getInsightPosts() -> AnyPublisher<[HomeInsightPostsModel], Never>
    func getGroupPosts() -> AnyPublisher<[HomeGroupPostModel], Never>
    func getCoffeeChatPosts() -> AnyPublisher<[HomeCoffeeChatPostModel], Never>
    func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Never>
    func getAnnouncementPosts() -> AnyPublisher<[HomeAnnouncementModel], Never>
}

public class DefaultHomeUseCase {
    
    private let repository: HomeRepositoryInterface
    
    public init(repository: HomeRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    public func getHomeDescription() -> AnyPublisher<HomeDescriptionModel, Never> {
        repository.getHomeDescription()
            .catch { error in
                return Empty<HomeDescriptionModel, Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getUserInfo() -> AnyPublisher<UserMainInfoModel?, Never> {
        repository.getUserInfo()
            .catch { error in
                return Empty<UserMainInfoModel?, Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Never> {
        repository.getRecentSchedule()
            .catch { error in
                return Empty<HomeRecentScheduleModel, Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Never> {
        repository.getAppServices()
            .catch { error in
                return Empty<[HomeAppServicesModel], Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getInsightPosts() -> AnyPublisher<[HomeInsightPostsModel], Never> {
        repository.getInsightPosts()
            .catch { error in
                return Empty<[HomeInsightPostsModel], Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getGroupPosts() -> AnyPublisher<[HomeGroupPostModel], Never> {
        repository.getGroupPosts()
            .catch { error in
                return Empty<[HomeGroupPostModel], Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getCoffeeChatPosts() -> AnyPublisher<[HomeCoffeeChatPostModel], Never> {
        repository.getCoffeeChatPosts()
            .catch { error in
                return Empty<[HomeCoffeeChatPostModel], Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getAnnouncementPosts() -> AnyPublisher<[HomeAnnouncementModel], Never> {
        repository.getAnnouncementPosts()
            .catch { error in
                return Empty<[HomeAnnouncementModel], Never>()
            }.eraseToAnyPublisher()
    }
    
    public func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Never> {
        repository.getCalendarDetail()
            .catch { error in
                return Empty<[HomeCalendarDetailModel], Never>()
            }
            .eraseToAnyPublisher()
    }
}
