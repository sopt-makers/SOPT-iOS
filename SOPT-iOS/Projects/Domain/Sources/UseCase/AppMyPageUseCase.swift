//
//  AppMyPageUseCase.swift
//  Domain
//
//  Created by Ian on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

import Combine

public protocol AppMyPageUseCase {
    func resetStamp()
    func deregisterPushToken()
    
    var resetSuccess: PassthroughSubject<Bool, Error> { get }
    var originUserNotificationIsAllowedStatus: PassthroughSubject<Bool, Error> { get }
    var optInPushNotificationResult: PassthroughSubject<Bool, Error> { get }
    var deregisterPushTokenSuccess: PassthroughSubject<Bool, Never> { get }
}

public final class DefaultAppMyPageUseCase {
    private let repository: AppMyPageRepositoryInterface
    
    public let resetSuccess = PassthroughSubject<Bool, Error>()
    public let originUserNotificationIsAllowedStatus = PassthroughSubject<Bool, Error>()
    public let optInPushNotificationResult = PassthroughSubject<Bool, Error>()
    public let deregisterPushTokenSuccess = PassthroughSubject<Bool, Never>()

    private let cancelBag = CancelBag()
    
    public init(repository: AppMyPageRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultAppMyPageUseCase: AppMyPageUseCase {
    public func resetStamp() {
        self.repository
            .resetStamp()
            .sink { success in
                self.resetSuccess.send(success)
            }.store(in: self.cancelBag)
    }
    
    public func deregisterPushToken() {
        guard let pushToken = UserDefaultKeyList.User.pushToken, !pushToken.isEmpty else { return }
        
        self.repository
            .deregisterPushToken(with: pushToken)
            .catch { _ in
                return Just(false)
            }.sink { [weak self] didSucceed in
                self?.deregisterPushTokenSuccess.send(didSucceed)
            }.store(in: self.cancelBag)
    }
}
