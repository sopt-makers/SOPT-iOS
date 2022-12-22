//
//  SentenceEditUseCase.swift
//  Domain
//
//  Created by Junho Lee on 2022/12/22.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol SentenceEditUseCase {

}

public class DefaultSentenceEditUseCase {
  
    private let repository: SettingRepositoryInterface
    private var cancelBag = CancelBag()
  
    public init(repository: SettingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSentenceEditUseCase: SentenceEditUseCase {
  
}
