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
import PokeFeature
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
        super.init()
    }
    
    public override func start(with option: DeepLinkOption?) {
        if let option {
            switch option {
            case .signInSuccess(let url):
                runSignInSuccessFlow(with: url)
            }
        } else {
            runSplashFlow()
        }
    }
}

// MARK: - Push Notification Binding

extension ApplicationCoordinator {
    private func bindNotification() {
        self.cancelBag.cancel()
        
        self.notificationHandler.deepLink
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is MainCoordinator })
            }
            .sink { [weak self] deepLinkComponent in
                self?.handleDeepLink(deepLink: deepLinkComponent)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
        
        self.notificationHandler.webLink
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is MainCoordinator })
            }.sink { [weak self] url in
                self?.handleWebLink(webLink: url)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
        
        self.notificationHandler.notificationLinkError
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is MainCoordinator })
            }.sink { [weak self] error in
                self?.handleNotificationLinkError(error: error)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
    }
    
    private func handleDeepLink(deepLink: DeepLinkComponentsExecutable) {
        self.router.dismissModule(animated: false)
        deepLink.execute(coordinator: self)
    }
    
    private func handleWebLink(webLink: String) {
        self.router.dismissModule(animated: false)
        self.router.pushSOPTWebView(url: webLink)
    }
    
    private func handleNotificationLinkError(error: NotificationLinkError) {
        switch error {
        case NotificationLinkError.linkNotFound:
            AlertUtils.presentAlertVC(type: .networkErr, title: I18N.DeepLink.updateAlertTitle,
                                      description: I18N.DeepLink.updateAlertDescription,
                                      customButtonTitle: I18N.DeepLink.updateAlertButtonTitle)
        case NotificationLinkError.expiredLink:
            AlertUtils.presentAlertVC(type: .networkErr, title: I18N.DeepLink.expiredLinkTitle,
                                      description: I18N.DeepLink.expiredLinkDesription,
                                      customButtonTitle: I18N.DeepLink.updateAlertButtonTitle)
        default:
            break
        }
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
    internal func runMainFlow(type: UserType? = nil) {
        defer {
            bindNotification()
        }
        
        self.childCoordinators = []
        
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
            case .poke:
                self?.runPokeFlow()
            case .pokeOnboarding:
                self?.runPokeOnboardingFlow()
            case .signIn:
                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                self?.removeDependency(coordinator)
            }
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    @discardableResult
    internal func runAttendanceFlow() -> AttendanceCoordinator {
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
        
        return coordinator
    }
    
    @discardableResult
    internal func runStampFlow() -> StampCoordinator {
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
        
        return coordinator
    }
    
    @discardableResult
    internal func runPokeFlow() -> PokeCoordinator {
        let coordinator = PokeCoordinator(
            router: Router(rootController: UIWindow.getRootNavigationController),
            factory: PokeBuilder()
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
    @discardableResult
    internal func runPokeOnboardingFlow() -> PokeOnboardingCoordinator {
        let coordinator = PokeOnboardingCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: PokeBuilder()
        )
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
    internal func runPokeNotificationListFlow() -> PokeNotificationListCoordinator {
        let coordinator = PokeNotificationListCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: PokeBuilder()
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
    
    @discardableResult
    internal func runMyPageFlow(of userType: UserType) -> MyPageCoordinator {
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
        
        return coordinator
    }
    
    @discardableResult
    internal func runNotificationFlow() -> NotificationCoordinator {
        let coordinator = NotificationCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: NotificationBuilder()
        )
        
        coordinator.requestCoordinating = { [weak self] destination in
            switch destination {
            case .deepLink(let url):
                self?.notificationHandler.receive(deepLink: url)
            case .webLink(let url):
                self?.notificationHandler.receive(webLink: url)
            }
        }
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
}
