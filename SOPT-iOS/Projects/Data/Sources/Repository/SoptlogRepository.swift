//
//  SoptlogRepository.swift
//  Data
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class SoptlogRepository {
    
    private let userService: UserService
    
    private let cancelBag = CancelBag()
    
    public init(userService: UserService) {
        self.userService = userService
    }
}

extension SoptlogRepository: SoptlogRepositoryInterface {
    public func fetchSoptlogModel() -> AnyPublisher<Domain.SoptlogModel, MainError> {
        return self.userService.fetchSoptlogInfo()
            .mapError{ error in
                guard let error = error as? APIError else {
                    return MainError.networkError(message: error.localizedDescription)
                }
                
                switch error {
                case .network(_, _):
                    return MainError.networkError(message: "networkError: \(error.localizedDescription)")
                case .tokenReissuanceFailed:
                    return MainError.authFailed
                default:
                    return MainError.networkError(message: error.localizedDescription)
                }
            }
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
