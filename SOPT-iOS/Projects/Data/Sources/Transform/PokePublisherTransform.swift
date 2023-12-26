//
//  PokePublisherTransform.swift
//  Data
//
//  Created by sejin on 12/26/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Domain
import Networks

public extension AnyPublisher where Output == PokeUserEntity, Failure == Error {
    func mapErrorToPokeError() -> AnyPublisher<PokeUserEntity, PokeError> {
        self.mapError { error in
            guard let apiError = error as? APIError else {
                return PokeError.networkError
            }
            
            switch apiError {
            case .network(let statusCode, let response):
                if statusCode == 400 {
                    return PokeError.exceedTodayPokeCount(message: response.responseMessage)
                }
                
                return PokeError.unknown(message: response.responseMessage)
            default:
                return PokeError.networkError
            }
        }.eraseToAnyPublisher()
    }
}
