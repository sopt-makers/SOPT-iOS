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
    var userMainInfo: PassthroughSubject<UserMainInfoModel?, Never> { get set }
    var serviceState: PassthroughSubject<ServiceStateModel, Never> { get set }
    var needSignIn: PassthroughSubject<Void, Never> { get set }
    var networkErrorOccured: PassthroughSubject<Void, Never> { get set }
    var unregisteredUserFound: PassthroughSubject<Void, Never> { get set }
    func getUserMainInfo()
    func getServiceState()
}

public class DefaultMainUseCase {
  
    private let repository: MainRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var userMainInfo = PassthroughSubject<UserMainInfoModel?, Never>()
    public var serviceState = PassthroughSubject<ServiceStateModel, Never>()
    public var needSignIn = PassthroughSubject<Void, Never>()
    public var networkErrorOccured = PassthroughSubject<Void, Never>()
    public var unregisteredUserFound = PassthroughSubject<Void, Never>()
  
    public init(repository: MainRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultMainUseCase: MainUseCase {
    public func getUserMainInfo() {
        repository.getUserMainInfo()
            .sink { [weak self] event in
                print("MainUseCase getUserMainInfo: \(event)")
                if case Subscribers.Completion.failure(let error) = event {
                    switch error {
                    case .networkError:
                        self?.networkErrorOccured.send()
                    case .authFailed:
                        self?.needSignIn.send()
                    case .unregisteredUser:
                        self?.unregisteredUserFound.send()
                    }
                }
            } receiveValue: { [weak self] userMainInfoModel in
                self?.setUserType(with: userMainInfoModel?.userType)
                self?.userMainInfo.send(userMainInfoModel)
            }.store(in: self.cancelBag)
    }
    
    public func getServiceState() {
        repository.getServiceState()
            .sink { [weak self] event in
                print("MainUseCase getServiceState: \(event)")
                if case Subscribers.Completion.failure(let _) = event {
                    self?.networkErrorOccured.send()
                }
            } receiveValue: { [weak self] serviceStateModel in
                self?.serviceState.send(serviceStateModel)
            }.store(in: self.cancelBag)
    }
    
    private func setUserType(with userType: UserType?) {
        switch userType {
        case .none, .unregisteredInactive, .inactive: // nil인 경우도 플그 미등록 유저로 취급
            UserDefaultKeyList.Auth.isActiveUser = false
        case .active:
            UserDefaultKeyList.Auth.isActiveUser = true
        default:
            UserDefaultKeyList.Auth.isActiveUser = false
        }
    }
}
