//
//  FindSocialViewController.swift
//  AuthFeature
//
//  Created by 장석우 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain

public final class SearchSocialAccountViewModel: SearchSocialAccountViewModelType {
    
    public struct Input {
        let phone: Driver<String>
        let verifySuccess: Driver<Void>
    }
    
    public struct Output {
        
    }
    
    private let useCase: SearchSocialAccountUseCase
    
    public var searchSocialAccountSucceed: ((OAuthProvider) -> Void)?
    
    public init(
        useCase: SearchSocialAccountUseCase
    ) {
        self.useCase = useCase
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.verifySuccess
            .withLatestFrom(input.phone)
            .flatMap(useCase.searchSocialAccount)
            .sink { [weak self] recentLogin in
                self?.searchSocialAccountSucceed?(recentLogin)
            }
            .store(in: cancelBag)

        return output
    }
}
