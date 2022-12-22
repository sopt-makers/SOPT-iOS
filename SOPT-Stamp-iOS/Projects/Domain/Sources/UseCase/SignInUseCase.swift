//
//  SignInUseCase.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol SignInUseCase {

}

public class DefaultSignInUseCase {
  
    private let repository: SignInRepositoryInterface
    private var cancelBag = CancelBag()
  
    public init(repository: SignInRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSignInUseCase: SignInUseCase {
  
}
