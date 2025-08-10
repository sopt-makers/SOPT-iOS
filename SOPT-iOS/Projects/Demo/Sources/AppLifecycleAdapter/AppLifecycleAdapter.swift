//
//  AppLifecycleAdapter.swift
//  SOPT-iOS-Demo
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain

final public class AppLifecycleAdapter {
    private let cancelBag = CancelBag()
}

// MARK: - Private functions
extension AppLifecycleAdapter {
    public func prepare() {
        self.onWillEnterForeground()
        self.onWillEnterBackground()
    }

    //MARK: - Usecases
    private func onWillEnterForeground() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink(receiveValue: { owner, _ in
                owner.reissueTokens()
                owner.checkNotificationSetting()
            }).store(in: self.cancelBag)
    }
    
    private func onWillEnterBackground() { }
}

// MARK: - Private functions
extension AppLifecycleAdapter {
    private func reissueTokens() {
        @Injected var tokenRepository: AuthTokensRepositoryInterface
        guard tokenRepository.fetch() != nil else { return }
        tokenRepository.refresh { _ in }
    }
    
    private func checkNotificationSetting() {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            let isNotificationAuthorized = setting.authorizationStatus == .authorized
            AmplitudeInstance.shared.addPushNotificationAuthorizationIdentity(isAuthorized: isNotificationAuthorized)
        }
    }
}
