//
//  AppLifecycleAdapter.swift
//  SOPT-iOS
//
//  Created by Ian on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Networks

import UIKit

final public class AppLifecycleAdapter {
    private let cancelBag = CancelBag()
    private let authService = DefaultAuthService()
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
            .sink(receiveValue: { [weak self] _ in
                self?.reissureTokens()
            }).store(in: self.cancelBag)
    }
    
    private func onWillEnterBackground() { }
}

// MARK: - Private functions
extension AppLifecycleAdapter {
    private func reissureTokens() {
        guard UserDefaultKeyList.Auth.appAccessToken != nil else { return }
        
        self.authService.reissuance { _  in }
    }
}
