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
    func getUserInfo() -> AnyPublisher<UserMainInfoModel?, MainError>
    func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Error>
    func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Error>
    func getPlaygroundNewsPosts() -> AnyPublisher<[HomePlaygroundNewsPostsModel], Error>
    func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Error>
    func getReportUrl() -> AnyPublisher<SoptampReportUrlModel, Error>
    func checkPokeNewUser() -> AnyPublisher<Bool, Error>
    func getFloatingButtonInfo() -> AnyPublisher<HomeFloatingButtonModel, Error>
    func getSurveyInfo() -> AnyPublisher<HomeSurveyModel, Error>
}
