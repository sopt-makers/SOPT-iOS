//
//  ApplicationCoordinator+Delegate.swift
//  RootFeature
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import HomeFeature
import SoptlogFeature
import TabBarFeature

// MARK: - HomeCoordinatorDelegate

extension ApplicationCoordinator: HomeCoordinatorDelegate {
    public func homeCoordinator(_ coordinator: HomeCoordinator, didRequest destination: HomeCoordinatorDestination) {
        switch destination {
        case .attendance:
            runAttendanceFlow()
        case .setting(let userType):
            runMyPageFlow(of: userType)
        case .signIn:
            runSignInFlow(by: .rootWindow(animated: true, message: nil))
            removeDependency(coordinator)
        case .notification:
            runNotificationFlow()
        case .soptlog:
            tabBarController?.selectedIndex = TabType.soptlog.rawValue
        case .deepLink(let url):
            notificationHandler.receive(deepLink: url)
            guard let deepLink = self.notificationHandler.deepLink.value else { return }
            handleDeepLink(deepLink: deepLink)
        case .webLink(let url):
            handleWebLink(webLink: url)
        case .calendar:
            showHomeCalendarDetail()
        case .poke(let isNewUser):
            isNewUser ? runPokeOnboardingFlow() : runPokeFlow()
        }
    }
}

// MARK: - SoptlogCoordinatorDelegate

extension ApplicationCoordinator: SoptlogCoordinatorDelegate {
    public func soptlogCoordinator(_ coordinator: SoptlogCoordinator, didRequest destination: SoptlogCoordinatorDestination) {
        switch destination {
        case .dailySoptune:
            self.runDailySoptuneFlow()
        case .signIn:
            self.runSignInFlow(by: .rootWindow(animated: true, message: nil))
        case .webLink(let url):
            self.handleWebLink(webLink: url)
        }
    }
}
