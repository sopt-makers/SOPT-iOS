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
    var isPokeNewUser: PassthroughSubject<Bool, Never> { get set }
    
    func getUserMainInfo()
    func getServiceState()
    func getMainViewDescription()
    func registerPushToken()
    func checkPokeNewUser()
}

public class DefaultMainUseCase {
  
    private let repository: MainRepositoryInterface
    private var cancelBag = CancelBag()
    
    public var userMainInfo = PassthroughSubject<UserMainInfoModel?, Never>()
    public var serviceState = PassthroughSubject<ServiceStateModel, Never>()
    public var mainDescription = PassthroughSubject<MainDescriptionModel, Never>()
    public var mainErrorOccurred = PassthroughSubject<MainError, Never>()
    public var isPokeNewUser = PassthroughSubject<Bool, Never>()
  
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
            .replaceError(with: .defaultDescription)
            .sink { [weak self] mainDescriptionModel in
                self?.mainDescription.send(mainDescriptionModel)
            }.store(in: self.cancelBag)
    }
    
    public func registerPushToken() {
        guard let pushToken = UserDefaultKeyList.User.pushToken, !pushToken.isEmpty else { return }

        repository.registerPushToken(with: pushToken)
            .sink { event in
                print("MainUseCase Register PushToken: \(event)")
            } receiveValue: { didSucceed in
                print("푸시 토큰 등록 결과: \(didSucceed)")
            }.store(in: cancelBag)
    }
    
    public func checkPokeNewUser() {
        repository.checkPokeNewUser()
            .catch { [weak self] error in
                print("MainUseCase CheckPokeNewUser Error: \(error)")
                self?.mainErrorOccurred.send(.networkError(message: "Poke 온보딩 대상 여부 확인 실패"))
                return Empty<Bool, Never>()
            }.sink { [weak self] isNewUser in
                self?.isPokeNewUser.send(isNewUser)
            }.store(in: cancelBag)
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
