//
//  SampleUseCase.swift
//  Network
//
//  Created by Junho Lee on 2022/11/09.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol SampleUseCase {

}

public class DefaultSampleUseCase {
  
    private let repository: SampleRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
  
    public init(repository: SampleRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSampleUseCase: SampleUseCase {
  
}
