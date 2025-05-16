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
    private let stampService: StampService
    private let pokeService: PokeService
    
    private let cancelBag = CancelBag()
    
    public init(homeService: HomeService,
                calendarService: CalendarService,
                userService: UserService,
                stampService: StampService,
                pokeService: PokeService
    ) {
        self.homeService = homeService
        self.calendarService = calendarService
        self.userService = userService
        self.stampService = stampService
        self.pokeService = pokeService
    }
}

extension HomeRepository: HomeRepositoryInterface {
    public func registerPushToken(with token: String) -> AnyPublisher<Bool, any Error> {
        userService.registerPushToken(with: token)
            .map {
                return 200..<300 ~= $0
            }
            .eraseToAnyPublisher()
    }
    
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
                    return MainError.networkError(message: error.localizedDescription)
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
    
    public func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], any Error> {
        calendarService.getCalendarDetail()
            .map{ $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    public func getReportUrl() -> AnyPublisher<Domain.SoptampReportUrlModel, any Error> {
        stampService.getReportUrl()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func checkPokeNewUser() -> AnyPublisher<Bool, any Error> {
        pokeService.isNewUser()
            .map{ $0.isNew }
            .eraseToAnyPublisher()
    }
}
