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
    func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Never>
    func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Never>
    func getReportURL()
    func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonModel, Never>
    
    func getHomeDescriptionAsync() async throws -> HomeDescriptionModel
    func getUserInfoAsync() async throws -> UserMainInfoModel?
    func getRecentScheduleAsync() async throws -> HomeRecentScheduleModel
    func getAppServicesAsync() async throws -> [HomeAppServicesModel]
    func getHomeAppService() async throws -> [HomeAppServicesModel]
    func getCalendarDetailAsync() async throws -> [HomeCalendarDetailModel]
    func getSurveyInfoAsync() async throws -> HomeSurveyModel
    func getPopularPostsAsync() async throws -> [HomePopularPostModel]
    func getLatestPostsAsync() async throws -> [HomeLatestPostModel]
}

public class DefaultHomeUseCase {
    
    private let repository: HomeRepositoryInterface
    private let cancelBag = CancelBag()
    
    // 앱 서비스 정보 캐시
    private var cachedAppServices: [HomeAppServicesModel]?
    
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

    public func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Never> {
        // 캐시된 데이터가 있으면 반환
        if let cached = cachedAppServices {
            return Just(cached).eraseToAnyPublisher()
        }
        
        // 없으면 API 호출 후 캐싱
        return repository.getAppServices()
            .handleEvents(receiveOutput: { [weak self] services in
                self?.cachedAppServices = services
            })
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
        // 캐시된 데이터가 있으면 반환
        if let cached = cachedAppServices {
            return cached
        }
        
        // 없으면 API 호출 후 캐싱
        let services = try await repository.getAppServicesAsync()
        cachedAppServices = services
        return services
    }
    
    // TODO: - 서버 명세 변경 시 tab / home appservie 변경
    public func getHomeAppService() async throws -> [HomeAppServicesModel] {
        // 캐시된 데이터가 있으면 반환
        if let cached = cachedAppServices {
            return cached
        }
        
        // 없으면 API 호출 후 캐싱
        let services = try await repository.getAppServicesAsync()
        
        cachedAppServices = services
        return services.filter { model in
            model.serviceName == "솝레터"
        }
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
