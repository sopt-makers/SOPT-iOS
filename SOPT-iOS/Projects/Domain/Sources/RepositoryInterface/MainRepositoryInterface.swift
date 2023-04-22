//
//  MainRepositoryInterface.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

import Combine

public protocol MainRepositoryInterface {
    func getUserMainInfo() -> AnyPublisher<UserMainInfoModel?, Never>
    func getServiceState() -> AnyPublisher<ServiceStateModel, Error>
}
