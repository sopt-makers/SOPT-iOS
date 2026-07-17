//
//  ApplicationCoordinator+Delegate.swift
//  RootFeature
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

import AuthFeature
import HomeFeature
import SoptlogFeature
import TabBarFeature
import AppMyPageFeature
import NotificationFeature
import StampFeature
import PokeFeature

// MARK: - AuthCoordinatorDelegate

extension ApplicationCoordinator: AuthCoordinatorDelegate {
    public func authCoordinator(_ coordinator: AuthCoordinator, userType: UserType) {
        self.runTabBarFlow(type: userType)
    }
}

// MARK: - TabBarCoordinatorDelegate

extension ApplicationCoordinator: TabBarCoordinatorDelegate {
    public func tabBarCoordinator(_ coordinator: TabBarCoordinator, to destination: TabBarCoordinatorDestination) {
        switch destination {
        case .home:
            self.selectedTab(.home)
        case .soptlog:
            self.selectedTab(.soptlog)
        case .poke:
            self.selectedTab(.poke)
//        case .soptamp:
//            self.selectedTab(.soptamp)
        case .signIn:
            clearChildViewControllers()
            self.runSignInFlow(by: .rootWindow(animated: true, message: nil))
        }
    }

    private func selectedTab(_ tab: TabBarItemType) {
        self.tabBarController?.selectedIndex = tab.getTabIndex(userType: UserDefaultKeyList.Auth.getUserType())
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
        case .notification:
            runNotificationFlow()
        case .soptlog:
            tabBarController?.selectedIndex = TabBarItemType.soptlog.rawValue
        case .appService(let type):
            // 임시
            runSoptletterOnboardingFlow()
        case .deepLink(let url):
            notificationHandler.receive(deepLink: url)
            guard let deepLink = self.notificationHandler.deepLink.value else { return }
            handleDeepLink(deepLink: deepLink)
        case .webLink(let url):
            handleWebLink(webLink: url)
        case .calendar:
            showHomeCalendarDetail()
        }
    }
}

// MARK: - SoptlogCoordinatorDelegate

extension ApplicationCoordinator: SoptlogCoordinatorDelegate {
    public func soptlogCoordinator(_ coordinator: SoptlogCoordinator, to destination: SoptlogCoordinatorDestination) {
        switch destination {
        case .dailySoptune:
            self.runDailySoptuneFlow()
        case .webLink(let url):
            self.handleWebLink(webLink: url)
//        case .soptamp:
//            self.selectedTab(.soptamp)
        case .pokeHome:
            self.selectedTab(.poke)
        case .pokeMyFriends(let relation):
            self.selectedTab(.poke)
            self.runPokeMyFriendsFlow(relation: relation)
        case .home:
            self.selectedTab(.home)
        case .signIn:
            clearChildViewControllers()
            runSignInFlow(by: .rootWindow(animated: true, message: nil))
        }
    }
}

// MARK: - NotificationCoordinatorDelegate

extension ApplicationCoordinator: NotificationCoordinatorDelegate {
    public func notificationCoordinator(_ coordinator: NotificationCoordinator, to destination: NotificationCoordinatorDestination) {
        switch destination {
        case .deepLink(let url):
            self.notificationHandler.receive(deepLink: url)
            guard let deepLink = self.notificationHandler.deepLink.value else { return }            
            handleDeepLink(deepLink: deepLink)
        case .webLink(let url):
            self.notificationHandler.receive(webLink: url)
            guard let webLink = self.notificationHandler.webLink.value else { return }
            handleWebLink(webLink: webLink)
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
        self.tabBarController?.viewControllers = []
        self.tabBarController = nil
        
        self.homeNavigationController.viewControllers.removeAll()
        self.stampNavigationController.viewControllers.removeAll()
        self.pokeNavigationController.viewControllers.removeAll()
        self.soptlogNavigationController.viewControllers.removeAll()
    }
}
