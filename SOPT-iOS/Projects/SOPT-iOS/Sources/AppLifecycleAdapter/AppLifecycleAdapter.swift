//
//  AppLifecycleAdapter.swift
//  SOPT-iOS
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
                owner.reissureTokens()
            }).store(in: self.cancelBag)
    }
    
    private func onWillEnterBackground() { }
}

// MARK: - Private functions
extension AppLifecycleAdapter {
    private func reissureTokens() {
        guard UserDefaultKeyList.Auth.appAccessToken != nil else { return }
        @Injected var tokenRepository: AuthTokensRepositoryInterface
        tokenRepository.refresh { _ in }
    }
}
