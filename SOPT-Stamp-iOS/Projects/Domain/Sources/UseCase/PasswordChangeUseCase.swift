//
//  PasswordChangeUseCase.swift
//  Domain
//
//  Created by sejin on 2022/12/26.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol PasswordChangeUseCase {

}

public class DefaultPasswordChangeUseCase {
  
    private let repository: PasswordChangeRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
  
    public init(repository: PasswordChangeRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPasswordChangeUseCase: PasswordChangeUseCase {
  
}
