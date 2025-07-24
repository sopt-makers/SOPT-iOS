//
//  HomeRepositoryInterface.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol HomeRepositoryInterface {
    func registerPushToken(with token: String) -> AnyPublisher<Bool, Error>
    func getHomeDescription() -> AnyPublisher<HomeDescriptionModel, Error>
    func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Error>
    func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Error>
    func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Error>
    func getReportUrl() -> AnyPublisher<SoptampReportUrlModel, Error>
    func checkPokeNewUser() -> AnyPublisher<Bool, Error>
    func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonModel, Error>
    
    /// async
    func getHomeDescriptionAsync() async throws -> HomeDescriptionModel
    func getUserInfoAsync() async throws -> UserMainInfoModel?
    func getRecentScheduleAsync() async throws -> HomeRecentScheduleModel
    func getAppServicesAsync() async throws -> [HomeAppServicesModel]
    func getCalendarDetailAsync() async throws -> [HomeCalendarDetailModel]
    func getReportURLAsync() async throws -> SoptampReportUrlModel
    func getSurveyInfoAsync() async throws -> HomeSurveyModel
    func getPopularPostsAsync() async throws -> [HomePopularPostModel]
    func getLatestPostsAsync() async throws -> [HomeLatestPostModel]
}
