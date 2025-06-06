//
//  FindSocialAccountUseCase.swift
//  Domain
//
//  Created by 장석우 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine
import Core

public protocol SearchSocialAccountUseCase {
    func searchSocialAccount(for phone: String) -> AnyPublisher<OAuthProvider, Never>
    var sideEffect: PassthroughSubject<Error, Never> { get }
}

public struct DefaultSearchSocialAccountUseCase: SearchSocialAccountUseCase {
    
    private let repository: CoreAuthRepositoryInterface
    
    private var cancelBag = CancelBag()
    
    public let sideEffect = PassthroughSubject<Error, Never>()
    
    public init(
        repository: CoreAuthRepositoryInterface
    ) {
        self.repository = repository
    }
        
    public func searchSocialAccount(
        for phone: String
    ) -> AnyPublisher<OAuthProvider, Never> {
        repository.searchSocialAccount(phone)
            .handleEvents(receiveOutput: { oAuthProvider in
                repository.saveRecentLogin(oAuthProvider)
            })
            .catch { error in
                sideEffect.send(error)
                return Empty<OAuthProvider, Never>()
            }
            .eraseToAnyPublisher()
    }
}
