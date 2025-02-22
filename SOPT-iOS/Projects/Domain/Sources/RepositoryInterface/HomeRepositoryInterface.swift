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
    func getHomeDescription() -> AnyPublisher<HomeDescriptionModel, Error>
    func getUserInfo() -> AnyPublisher<UserMainInfoModel?, MainError>
    func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Error>
    func getAppServices() -> AnyPublisher<[HomeAppServicesModel], Error>
    func getInsightPosts() -> AnyPublisher<[HomeInsightPostsModel], Error>
    func getGroupPosts() -> AnyPublisher<[HomeGroupPostModel], Error>
    func getCoffeeChatPosts() -> AnyPublisher<[HomeCoffeeChatPostModel], Error>
    func getCalendarDetail() -> AnyPublisher<[HomeCalendarDetailModel], Error>
    func getAnnouncementPosts() -> AnyPublisher<[HomeAnnouncementModel], Error>
    func getReportUrl() -> AnyPublisher<SoptampReportUrlModel, Error>
}
