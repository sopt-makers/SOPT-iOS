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
    func fetchUserNotificationIsAllowed()
    func optInPushNotificationInGeneral(to isOn: Bool)
    
    var resetSuccess: PassthroughSubject<Bool, Error> { get }
    var originUserNotificationIsAllowedStatus: PassthroughSubject<Bool, Error> { get }
    var optInPushNotificationResult: PassthroughSubject<Bool, Error> { get }
}

public final class DefaultAppMyPageUseCase {
    private let repository: AppMyPageRepositoryInterface
    
    public let resetSuccess = PassthroughSubject<Bool, Error>()
    public let originUserNotificationIsAllowedStatus = PassthroughSubject<Bool, Error>()
    public let optInPushNotificationResult = PassthroughSubject<Bool, Error>()

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
    
    public func fetchUserNotificationIsAllowed() {
        self.repository
            .getNotificationIsAllowed()
            .sink { isAllowed in
                self.originUserNotificationIsAllowedStatus.send(isAllowed)
            }.store(in: self.cancelBag)
    }
    
    public func optInPushNotificationInGeneral(to isOn: Bool) {
        self.repository
            .optInPushNotificationInGeneral(to: isOn)
            .sink { isOn in
                self.optInPushNotificationResult.send(isOn)
            }.store(in: self.cancelBag)
    }
}
