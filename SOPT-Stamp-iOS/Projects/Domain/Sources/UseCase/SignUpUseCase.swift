//
//  SignUpUseCase.swift
//  Domain
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol SignUpUseCase {

}

public class DefaultSignUpUseCase {
  
    private let repository: SignUpRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
  
    public init(repository: SignUpRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSignUpUseCase: SignUpUseCase {
  
}
