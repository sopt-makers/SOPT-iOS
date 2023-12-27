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
    func getUserMainInfo() -> AnyPublisher<UserMainInfoModel?, MainError>
    func getServiceState() -> AnyPublisher<ServiceStateModel, MainError>
    func getMainViewDescription() -> AnyPublisher<MainDescriptionModel, MainError>
    func registerPushToken(with token: String) -> AnyPublisher<Bool, Error>
    func checkPokeNewUser() -> AnyPublisher<Bool, Error>
}
