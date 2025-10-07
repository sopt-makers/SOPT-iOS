//
//  ApplicationCoordinator+Delegate.swift
//  RootFeature
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

import HomeFeature
import SoptlogFeature
import TabBarFeature
import AppMyPageFeature
import NotificationFeature

// MARK: - TabBarCoordinatorDelegate

extension ApplicationCoordinator: TabBarCoordinatorDelegate {
    public func tabBarCoordinator(_ coordinator: TabBarCoordinator, to destination: TabBarCoordinatorDestination) {
        switch destination {
        case .home:
            self.selectedTab(.home)
        case .soptlog:
            self.selectedTab(.soptlog)
        case .signIn:
            clearChildViewControllers()
            self.runSignInFlow(by: .rootWindow(animated: true, message: nil))
            self.removeDependency(coordinator)
        }
    }

    private func selectedTab(_ tab: TabType) {
        self.tabBarController?.selectedIndex = tab.rawValue
    }
}

// MARK: - HomeCoordinatorDelegate

extension ApplicationCoordinator: HomeCoordinatorDelegate {
    public func homeCoordinator(_ coordinator: HomeCoordinator, to destination: HomeCoordinatorDestination) {
        switch destination {
        case .attendance:
            runAttendanceFlow()
        case .setting(let userType):
            runMyPageFlow(of: userType)
        case .signIn:
            clearChildViewControllers()
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
            _ = isNewUser ? runPokeOnboardingFlow() : runPokeFlow()
        }
    }
}

// MARK: - SoptlogCoordinatorDelegate

extension ApplicationCoordinator: SoptlogCoordinatorDelegate {
    public func soptlogCoordinator(_ coordinator: SoptlogCoordinator, to destination: SoptlogCoordinatorDestination) {
        switch destination {
        case .dailySoptune:
            self.runDailySoptuneFlow()
        case .signIn:
            clearChildViewControllers()
            self.runSignInFlow(by: .rootWindow(animated: true, message: nil))
        case .webLink(let url):
            self.handleWebLink(webLink: url)
        }
    }
}

// MARK: - NotificationCoordinatorDelegate

extension ApplicationCoordinator: NotificationCoordinatorDelegate {
    public func notificationCoordinator(_ coordinator: NotificationCoordinator, to destination: NotificationCoordinatorDestination) {
        switch destination {
        case .deepLink(let url):
            self.notificationHandler.receive(deepLink: url)
        case .webLink(let url):
            self.notificationHandler.receive(webLink: url)
        }
    }
}

// MARK: - MyPageCoordinatorDelegate

extension ApplicationCoordinator: MyPageCoordinatorDelegate {
    public func myPageCoordinator(_ coordinator: MyPageCoordinator, to destination: MyPageCoordinatorDestination) {
        clearChildViewControllers()
        switch destination {
        case .signIn:
            self.runSignInFlow(by: .rootWindow(animated: true, message: nil))
        case .signInWithToast:
            self.runSignInFlow(by: .rootWindow(animated: true, message: I18N.Setting.Withdrawal.withdrawalSuccess))
        }
    }
}

extension ApplicationCoordinator {
    private func clearChildViewControllers() {
        self.homeNavigationController.viewControllers.removeAll()
        self.soptlogNavigationController.viewControllers.removeAll()
    }
}
