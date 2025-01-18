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
    func getRecentSchedule() -> AnyPublisher<HomeRecentScheduleModel, Error>
}
