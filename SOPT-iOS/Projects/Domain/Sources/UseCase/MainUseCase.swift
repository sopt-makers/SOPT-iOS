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
    var userMainInfo: PassthroughSubject<UserMainInfoModel?, Error> { get set }
    var serviceState: PassthroughSubject<ServiceStateModel, Error> { get set }
    func getUserMainInfo()
    func getServiceState()
}

public class DefaultMainUseCase {
  
    private let repository: MainRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var userMainInfo = PassthroughSubject<UserMainInfoModel?, Error>()
    public var serviceState = PassthroughSubject<ServiceStateModel, Error>()
  
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
    
    public func getServiceState() {
        repository.getServiceState()
            .sink { event in
                print("MainUseCase: \(event)")
            } receiveValue: { [weak self] serviceStateModel in
                self?.serviceState.send(serviceStateModel)
            }.store(in: self.cancelBag)
    }
}
