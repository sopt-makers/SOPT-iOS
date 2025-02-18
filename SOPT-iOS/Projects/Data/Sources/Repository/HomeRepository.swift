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
    private let userService: UserService
    
    private let cancelBag = CancelBag()
    
    public init(homeService: HomeService,
                calendarService: CalendarService,
                userService: UserService
    ) {
        self.homeService = homeService
        self.calendarService = calendarService
        self.userService = userService
    }
}

extension HomeRepository: HomeRepositoryInterface {
    
    public func getAppServices() -> AnyPublisher<[Domain.HomeAppServicesModel], any Error> {
        homeService.getAppServiceAccessStatus()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getUserInfo() -> AnyPublisher<Domain.UserMainInfoModel?, Domain.MainError> {
        userService.getUserMainInfo()
            .mapError { error -> MainError in
                guard let error = error as? APIError else {
                    return MainError.networkError(message: error.localizedDescription)
                }
                
                switch error {
                case .network(let statusCode, _):
                    if statusCode == 401 {
                        return MainError.authFailed
                    }
                    return MainError.networkError(message: "\(statusCode) 네트워크 에러")
                case .tokenReissuanceFailed:
                    return MainError.authFailed
                default:
                    return MainError.networkError(message: "API 에러 디폴트")
                }
            }
            .map { $0.toDomain() }
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
    
    public func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], any Error> {
        calendarService.getCalendarDetail()
            .map{ $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getAnnouncementPosts() -> AnyPublisher<[Domain.HomeAnnouncementModel], any Error> {
        homeService.getHomeEmploymentEntity()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
