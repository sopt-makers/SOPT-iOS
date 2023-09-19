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
    var mainDescription: PassthroughSubject<MainDescriptionModel, Never> { get set }
    var mainErrorOccurred: PassthroughSubject<MainError, Never> { get set }
    func getUserMainInfo()
    func getServiceState()
    func getMainViewDescription()
}

public class DefaultMainUseCase {
  
    private let repository: MainRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var userMainInfo = PassthroughSubject<UserMainInfoModel?, Never>()
    public var serviceState = PassthroughSubject<ServiceStateModel, Never>()
    public var mainDescription = PassthroughSubject<MainDescriptionModel, Never>()
    public var mainErrorOccurred = PassthroughSubject<MainError, Never>()
  
    public init(repository: MainRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultMainUseCase: MainUseCase {
    public func getUserMainInfo() {
        repository.getUserMainInfo()
            .catch { [weak self] error in
                print("MainUseCase getUserMainInfo error occurred: \(error)")
                self?.mainErrorOccurred.send(error)
                return Just<UserMainInfoModel?>(nil).eraseToAnyPublisher()
            }
            .sink { [weak self] userMainInfoModel in
                self?.setUserType(with: userMainInfoModel?.userType)
                self?.userMainInfo.send(userMainInfoModel)
            }.store(in: self.cancelBag)
    }
    
    public func getServiceState() {
        repository.getServiceState()
            .sink { [weak self] event in
                print("MainUseCase getServiceState: \(event)")
                if case Subscribers.Completion.failure = event {
                    self?.mainErrorOccurred.send(.networkError(message: "GetServiceState 실패"))
                }
            } receiveValue: { [weak self] serviceStateModel in
                self?.serviceState.send(serviceStateModel)
            }.store(in: self.cancelBag)
    }
    
    public func getMainViewDescription() {
        repository.getMainViewDescription()
            .sink { [weak self] event in
                print("MainUseCase getMainViewDescription: \(event)")
                if case Subscribers.Completion.failure = event {
                    self?.mainErrorOccurred.send(.networkError(message: "GetMainViewDescription 실패"))
                }
            } receiveValue: { [weak self] mainDescriptionModel in
                self?.mainDescription.send(mainDescriptionModel)
            }.store(in: self.cancelBag)
    }
    
    private func setUserType(with userType: UserType?) {
        switch userType {
        case .none, .inactive:
            UserDefaultKeyList.Auth.isActiveUser = false
        case .active:
            UserDefaultKeyList.Auth.isActiveUser = true
        default:
            UserDefaultKeyList.Auth.isActiveUser = false
        }
    }
}
