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
    public func fetchSoptlogModel() async throws -> SoptlogModel {
        do {
            return try await self.userService.fetchSoptlogInfo().toDomain()
        } catch(let error) {
            guard let error = error as? APIError else {
                throw MainError.networkError(message: error.localizedDescription)
            }
            
            switch error {
            case .network(let statusCode, _):
                throw MainError.networkError(message: "🚨 code: \(statusCode)\nnetworkError: \(error.localizedDescription)")
            case .tokenReissuanceFailed:
                throw MainError.authFailed
            default:
                throw MainError.networkError(message: error.localizedDescription)
            }
        }
    }
}
