//
//  AppNoticeUseCase.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Combine

import Core

public protocol AppNoticeUseCase {

}

public class DefaultAppNoticeUseCase {
  
    private let repository: AppNoticeRepositoryInterface
    private var cancelBag = CancelBag()

    public init(repository: AppNoticeRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultAppNoticeUseCase: AppNoticeUseCase {

}
