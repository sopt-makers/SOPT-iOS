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
    
    public func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonModel, any Error> {
        homeService.getFloatingButtonInfo()
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getHomeDescriptionAsync() async throws -> Domain.HomeDescriptionModel {
        let entity = try await homeService.getDescriptionAsync()
        return entity.toDomain()
    }
    
    public func getUserInfoAsync() async throws -> Domain.UserMainInfoModel? {
        do {
            let entity = try await userService.getUserMainInfoAsync()
            return entity.toDomain()
        } catch let error as APIError {
            switch error {
            case .network(let statusCode, _):
                if statusCode == 401 {
                    throw MainError.authFailed
                }
                throw MainError.networkError(message: "\(statusCode) 네트워크 에러")
            case .tokenReissuanceFailed:
                throw MainError.authFailed
            default:
                throw MainError.networkError(message: error.localizedDescription)
            }
        } catch {
            throw MainError.networkError(message: error.localizedDescription)
        }
    }
    
    public func getRecentScheduleAsync() async throws -> Domain.HomeRecentScheduleModel {
        let entity = try await calendarService.getRecentScheduleAsync()
        return entity.toDomain()
    }
    
    public func getAppServicesAsync() async throws -> [Domain.HomeAppServicesModel] {
        let entity = try await homeService.getAppServiceAccessStatusAsync()
        return entity.map { $0.toDomain() }
    }
    
    public func getCalendarDetailAsync() async throws -> [Domain.HomeCalendarDetailModel] {
        let entity = try await calendarService.getCalendarDetailAsync()
        return entity.map { $0.toDomain() }
    }
    
    public func getReportURLAsync() async throws -> Domain.SoptampReportUrlModel {
        let entity = try await stampService.getReportURLAsync()
        return entity.toDomain()
    }
    
    public func getSurveyInfoAsync() async throws -> Domain.HomeSurveyModel {
        let entity = try await homeService.getSurveyInfoAsync()
        return entity.toDomain()
    }
    
    public func getPopularPostsAsync() async throws -> [Domain.HomePopularPostModel] {
        let entity = try await homeService.getPopularPostsAsync()
        return entity.map { $0.toDomain() }
    }
    
    public func getLatestPostsAsync() async throws -> [Domain.HomeLatestPostModel] {
        let entity = try await homeService.getLatestPostsAsync()
        return entity.map { $0.toDomain() }
    }
}
