//
//  MainUseCase.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol MainUseCase {

}

public class DefaultMainUseCase {
  
    private let repository: MainRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
  
    public init(repository: MainRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultMainUseCase: MainUseCase {
  
}
