//
//  RootFeature.swift
//  RootFeature
//
//  Created by 김영인 on 2023/03/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import SplashFeature
import AuthFeature
import MainFeature
import AppMyPageFeature
import NotificationFeature
import StampFeature
import AttendanceFeature

public
final class ApplicationCoordinator: BaseCoordinator {
    
    //  private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private var cancelBag = CancelBag()
    private let notificationHandler: NotificationHandler
    
    public init(router: Router, notificationHandler: NotificationHandler) {
        self.router = router
        self.notificationHandler = notificationHandler
    }
    
    public override func start(with option: DeepLinkOption?) {
        if let option {
            switch option {
            case .signInSuccess(let url):
                runSignInSuccessFlow(with: url)
            default:
                runSplashFlow()
            }
        } else {
            runSplashFlow()
        }
    }
}

// MARK: - Push Notification Binding

extension ApplicationCoordinator {
    private func bindNotification() {
        cancelBag.cancel()
        self.notificationHandler.$notificationId
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] id in
                guard let self = self, let id = Int(id) else { return }
                self.router.dismissModule(animated: false)
                self.runNotificationFlow(with: .notificationDetail(notificationId: id))
                self.notificationHandler.notificationId = nil
            }.store(in: cancelBag)
    }
}

// MARK: - SplashFlow

extension ApplicationCoordinator {
    private func runSplashFlow() {
        let coordinator = SplashCoordinator(router: router, factory: SplashBuilder())
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.checkDidSignIn()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func checkDidSignIn() {
        let needAuth = UserDefaultKeyList.Auth.appAccessToken == nil
        needAuth ? runSignInFlow(by: .modal) : runMainFlow()
    }
}

// MARK: - SignInFlow

extension ApplicationCoordinator {
    private func runSignInFlow(by style: CoordinatorStartingOption) {
        let coordinator = AuthCoordinator(router: router, factory: AuthBuilder())
        coordinator.finishFlow = { [weak self, weak coordinator] userType in
            self?.runMainFlow(type: userType)
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(by: style)
    }
    
    private func runSignInSuccessFlow(with url: String) {
        childCoordinators = []
        let coordinator = AuthCoordinator(router: router, factory: AuthBuilder(), url: url)
        coordinator.finishFlow = { [weak self, weak coordinator] userType in
            self?.runMainFlow(type: userType)
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(by: .rootWindow(animated: false, message: nil))
    }
}

// MARK: - MainFlow

extension ApplicationCoordinator {
    private func runMainFlow(type: UserType? = nil) {
        defer {
            bindNotification()
        }
        
        let userType = type ?? UserDefaultKeyList.Auth.getUserType()
        let coordinator = MainCoordinator(
            router: router,
            factory: MainBuilder(),
            userType: userType
        )
        coordinator.requestCoordinating = { [weak self, weak coordinator] destination in
            switch destination {
            case .myPage(let userType):
                self?.runMyPageFlow(of: userType)
            case .notification:
                self?.runNotificationFlow()
            case .attendance:
                self?.runAttendanceFlow()
            case .stamp:
                self?.runStampFlow()
            case .signIn:
                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                self?.removeDependency(coordinator)
            }
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runAttendanceFlow() {
        let coordinator = AttendanceCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: AttendanceBuilder()
        )
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runStampFlow() {
        let coordinator = StampCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: StampBuilder()
        )
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMyPageFlow(of userType: UserType) {
        let coordinator = MyPageCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: MyPageBuilder(),
            userType: userType
        )
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        coordinator.requestCoordinating = { [weak self, weak coordinator] destination in
            self?.removeDependency(coordinator)
            self?.childCoordinators = []
            switch destination {
            case .signIn:
                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
            case .signInWithToast:
                self?.runSignInFlow(by: .rootWindow(animated: true, message: I18N.Setting.Withdrawal.withdrawalSuccess))
            }
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runNotificationFlow(with option: DeepLinkOption? = nil) {
        let coordinator = NotificationCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: NotificationBuilder()
        )
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(with: option)
    }
}
