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
    func registerPushToken()
    func getHomeDescription() -> AnyPublisher<HomeDescriptionModel, Never>
    func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Never>
    func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Never>
    func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Never>
    func getReportURL()
    func checkPokeNewUser() -> AnyPublisher<Bool, Never>
    func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonModel, Never>
    
    func getHomeDescriptionAsync() async throws -> HomeDescriptionModel
    func getUserInfoAsync() async throws -> UserMainInfoModel?
    func getRecentScheduleAsync() async throws -> HomeRecentScheduleModel
    func getAppServicesAsync() async throws -> [HomeAppServicesModel]
    func getCalendarDetailAsync() async throws -> [HomeCalendarDetailModel]
    func getSurveyInfoAsync() async throws -> HomeSurveyModel
    func getPopularPostsAsync() async throws -> [HomePopularPostModel]
    func getLatestPostsAsync() async throws -> [HomeLatestPostModel]
}

public class DefaultHomeUseCase {
    
    private let repository: HomeRepositoryInterface
    private let cancelBag = CancelBag()
    
    public init(repository: HomeRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultHomeUseCase: HomeUseCase {
    public func registerPushToken() {
        guard let pushToken = UserDefaultKeyList.User.pushToken, !pushToken.isEmpty else { return }
        
        repository.registerPushToken(with: pushToken)
            .sink { event in
                print("MainUseCase Register PushToken: \(event)")
            } receiveValue: { didSucceed in
                print("푸시 토큰 등록 결과: \(didSucceed)")
            }.store(in: cancelBag)
    }
    
    public func getHomeDescription() -> AnyPublisher<HomeDescriptionModel, Never> {
        repository.getHomeDescription()
            .catch { error in
                return Empty<HomeDescriptionModel, Never>()
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

    public func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Never> {
        repository.getCalendarDetail()
            .catch { error in
                return Empty<[HomeCalendarDetailModel], Never>()
            }
            .eraseToAnyPublisher()
    }
    
    public func getReportURL() {
        repository.getReportUrl()
            .withUnretained(self)
            .sink { event in
                print("GetReportUrl State: \(event)")
            } receiveValue: { owner, resultModel in
                UserDefaultKeyList.Soptamp.reportUrl = resultModel.reportUrl
            }.store(in: cancelBag)
    }
    
    public func checkPokeNewUser() -> AnyPublisher<Bool, Never> {
        repository.checkPokeNewUser()
            .catch { error in
                print("HomeUseCase checkPokeNewUser에서 문제가 발생했습니다. \(error)")
                return Empty<Bool, Never>()
            }
            .eraseToAnyPublisher()
    }
    
    public func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonModel, Never> {
        repository.getFloatingButtonInfo()
            .catch { error in
                print("HomeUseCase getFloatingButtonInfo에서 문제가 발생했습니다. \(error)")
                return Empty<HomeFloatingButtonModel, Never>()
            }
            .eraseToAnyPublisher()
    }
    
    public func getHomeDescriptionAsync() async throws -> HomeDescriptionModel {
        try await repository.getHomeDescriptionAsync()
    }
    
    public func getUserInfoAsync() async throws -> UserMainInfoModel? {
        try await repository.getUserInfoAsync()
    }
    
    public func getRecentScheduleAsync() async throws -> HomeRecentScheduleModel {
        try await repository.getRecentScheduleAsync()
    }
    
    public func getAppServicesAsync() async throws -> [HomeAppServicesModel] {
        try await repository.getAppServicesAsync()
    }

    public func getCalendarDetailAsync() async throws -> [HomeCalendarDetailModel] {
        try await repository.getCalendarDetailAsync()
    }

    public func getSurveyInfoAsync() async throws -> HomeSurveyModel {
        try await repository.getSurveyInfoAsync()
    }
    
    public func getPopularPostsAsync() async throws -> [HomePopularPostModel] {
        try await repository.getPopularPostsAsync()
    }
    
    public func getLatestPostsAsync() async throws -> [HomeLatestPostModel] {
        try await repository.getLatestPostsAsync()
    }
}
