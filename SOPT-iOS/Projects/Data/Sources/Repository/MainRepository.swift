//
//  MainRepository.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class MainRepository {
    
    private let userService: UserService
    private let configService: ConfigService
    private let descriptionService: DescriptionService
    private let pokeService: PokeService
    
    private let cancelBag = CancelBag()
    
    public init(userService: UserService, configService: ConfigService, descriptionService: DescriptionService, pokeService: PokeService) {
        self.userService = userService
        self.configService = configService
        self.descriptionService = descriptionService
        self.pokeService = pokeService
    }
}

extension MainRepository: MainRepositoryInterface {
    public func getUserMainInfo() -> AnyPublisher<Domain.UserMainInfoModel?, MainError> {
        return userService.getUserMainInfo()
            .mapError { error -> MainError in
                guard let error = error as? APIError else {
                    return MainError.networkError(message: "Moya 에러")
                }
                
                switch error {
                case .network(let statusCode, _):
                    if statusCode == 401 {
                        return MainError.authFailed
                    }
                    return MainError.networkError(message: "\(statusCode) 네트워크 에러")
                case .tokenReissuanceFailed:
                    return MainError.authFailed
                default:
                    return MainError.networkError(message: "API 에러 디폴트")
                }
            }
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getServiceState() -> AnyPublisher<ServiceStateModel, MainError> {
        configService.getServiceAvailability()
            .mapError { error in
                print(error)
                return MainError.networkError(message: "GetServiceState 에러")
            }
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getMainViewDescription() -> AnyPublisher<MainDescriptionModel, MainError> {
        descriptionService.getMainViewDescription()
            .mapError { error in
                print(error)
                return MainError.networkError(message: "GetMainViewDescription 에러")
            }
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func registerPushToken(with token: String) -> AnyPublisher<Bool, Error> {
        userService.registerPushToken(with: token)
            .map {
                return 200..<300 ~= $0
            }
            .eraseToAnyPublisher()
    }
    
    public func checkPokeNewUser() -> AnyPublisher<Bool, Error> {
        pokeService.isNewUser()
            .map { $0.isNew }
            .eraseToAnyPublisher()
    }
}
