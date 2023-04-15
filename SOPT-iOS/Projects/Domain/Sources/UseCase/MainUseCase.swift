//
//  MainUseCase.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

import Combine

public protocol MainUseCase {
    func getUserMainInfo()
    var userMainInfo: PassthroughSubject<UserMainInfoModel?, Error> { get set }
}

public class DefaultMainUseCase {
  
    private let repository: MainRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var userMainInfo = PassthroughSubject<UserMainInfoModel?, Error>()
  
    public init(repository: MainRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultMainUseCase: MainUseCase {
    public func getUserMainInfo() {
        repository.getUserMainInfo()
            .sink { event in
                print("MainUseCase: \(event)")
            } receiveValue: { [weak self] userMainInfoModel in
                self?.userMainInfo.send(userMainInfoModel)
            }.store(in: self.cancelBag)
    }
}
