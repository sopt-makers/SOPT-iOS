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
    func getUserInfo() -> AnyPublisher<UserMainInfoModel?, MainError>
    func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Never>
    func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Never>
    func getInsightPosts() -> AnyPublisher<[HomeInsightPostsModel], Never>
    func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Never>
    func getReportURL()
    func checkPokeNewUser() -> AnyPublisher<Bool, Never>
    func getFABInfo() -> AnyPublisher<HomeFABModel, Never>
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
    
    public func getUserInfo() -> AnyPublisher<UserMainInfoModel?, MainError> {
        repository.getUserInfo()
            .eraseToAnyPublisher()
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
    
    public func getFABInfo() -> AnyPublisher<HomeFABModel, Never> {
        repository.getFABInfo()
            .catch { error in
                return Empty<HomeFABModel, Never>()
            }
            .eraseToAnyPublisher()
    }
}
