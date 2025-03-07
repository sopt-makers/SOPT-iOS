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
//import MainFeature
import HomeFeature
import AppMyPageFeature
import NotificationFeature
import StampFeature
import PokeFeature
import AttendanceFeature
import DailySoptuneFeature
import WebFeature
import SoptlogFeature
import HomeFeature
import TabBarFeature

public
final class ApplicationCoordinator: BaseCoordinator {
    
    private let router: Router
    private var cancelBag = CancelBag()
    private let notificationHandler: NotificationHandler
    
    private weak var rootController: UINavigationController?
    private weak var tabBarController: UITabBarController?
    
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
                self.childCoordinators.contains(where: { $0 is TabBarCoordinator })
            }
            .sink { [weak self] deepLinkComponent in
                self?.handleDeepLink(deepLink: deepLinkComponent)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
        
        self.notificationHandler.webLink
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is TabBarCoordinator })
            }.sink { [weak self] url in
                self?.handleWebLink(webLink: url)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
        
        self.notificationHandler.notificationLinkError
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is TabBarCoordinator })
            }.sink { [weak self] error in
                self?.handleNotificationLinkError(error: error)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
    }
    
    private func handleDeepLink(deepLink: DeepLinkComponentsExecutable) {
        self.rootController?.dismiss(animated: false)
        deepLink.execute(coordinator: self)
    }
    
    private func handleWebLink(webLink: String) {
        self.router.dismissModule(animated: false)
        guard let url = URL(string: webLink) else { return }
        let webView = SOPTWebView(startWith: url)
        self.router.push(webView)
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
        needAuth ? runSignInFlow(by: .root) : runTabBarFlow()
    }
}

// MARK: - SignInFlow

extension ApplicationCoordinator {
    private func runSignInFlow(by style: CoordinatorStartingOption) {
        let coordinator = AuthCoordinator(router: router, factory: AuthBuilder())
        coordinator.finishFlow = { [weak self, weak coordinator] userType in
            self?.runTabBarFlow(type: userType)
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(by: style)
    }
    
    private func runSignInSuccessFlow(with url: String) {
        childCoordinators = []
        let coordinator = AuthCoordinator(router: router, factory: AuthBuilder(), url: url)
        coordinator.finishFlow = { [weak self, weak coordinator] userType in
            self?.runTabBarFlow(type: userType)
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(by: .rootWindow(animated: false, message: nil))
    }
}

// MARK: - MainFlow

extension ApplicationCoordinator {
    internal func runTabBarFlow(type: UserType? = nil) {
        defer {
            bindNotification()
        }
        
        self.childCoordinators = []
        
        let tabBarBuilder = TabBarBuilder()
        let userType = type ?? UserDefaultKeyList.Auth.getUserType()

        let homeCoordinator = runHomeFlow(type: userType)
        guard let homeVC = homeCoordinator.rootViewController else { return }
        
        let soptlogCoordinator = runSoptlogFlow()
        guard let soptlogVC = soptlogCoordinator.rootViewController else { return }
                
        let (tabbarController, viewModel) = tabBarBuilder.makeTabBar(
            with: [homeVC,
                   soptlogVC],
            userType: userType
        )
        
        let coordinator = TabBarCoordinator(
            router: router,
            factory: (tabbarController, viewModel),
            items: [
                homeVC,
                soptlogVC
            ]
        )
                        
        self.rootController = tabbarController.asNavigationController
        self.tabBarController = tabbarController
        
        // 각 코디네이터 실행
        coordinator.requestCoordinating = { [weak self] destination in
            switch destination {
            case .home:
                homeCoordinator.requestCoordinating = { [weak self, weak coordinator] destination in
                    switch destination {
                    case .attendance:
                        self?.runAttendanceFlow()
                    case .setting(let userType):
                        self?.runMyPageFlow(of: userType)
                    case .signIn:
                        self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                        self?.removeDependency(coordinator)
                    case .notification:
                        self?.runNotificationFlow()
                    case .soptlog:
                        self?.tabBarController?.selectedIndex = 1
                    case .deepLink(let url):
                        self?.notificationHandler.receive(deepLink: url)
                        guard let deepLink = self?.notificationHandler.deepLink.value else { return }
                        self?.handleDeepLink(deepLink: deepLink)
                    case .webLink(let url):
                        self?.handleWebLink(webLink: url)
                    case .calendar:
                        self?.showHomeCalendarDetail()
                    }
                }
            case .soptlog:
                soptlogCoordinator.requestCoordinating = { [weak self] destination in
                    switch destination {
                    case .dailySoptune:
                        self?.runDailySoptuneFlow()
                    case .signIn:
                        self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                    case .webLink(let url):
                        self?.handleWebLink(webLink: url)
                    }
                }
            case .signIn:
                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                self?.removeDependency(coordinator)
            }
        }
        
        addDependency(coordinator)
        coordinator.start()
    }

//    internal func runMainFlow(type: UserType? = nil) {
//        defer {
//            bindNotification()
//        }
//        
//        self.childCoordinators = []
//        
//        let userType = type ?? UserDefaultKeyList.Auth.getUserType()
//        let coordinator = MainCoordinator(
//            router: router,
//            factory: MainBuilder(),
//            userType: userType
//        )
//        coordinator.requestCoordinating = { [weak self, weak coordinator] destination in
//            switch destination {
//            case .myPage(let userType):
//                self?.runMyPageFlow(of: userType)
//            case .notification:
//                self?.runNotificationFlow()
//            case .attendance:
//                self?.runAttendanceFlow()
//            case .stamp:
//                self?.runStampFlow()
//            case .poke:
//                self?.runPokeFlow()
//            case .pokeOnboarding:
//                self?.runPokeOnboardingFlow()
//            case .signIn:
//                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
//                self?.removeDependency(coordinator)
//            }
//        }
//        addDependency(coordinator)
//        coordinator.start()
//    }
    
    @discardableResult
    internal func runHomeFlow(type: UserType? = nil) -> HomeCoordinator {
        let userType = type ?? UserDefaultKeyList.Auth.getUserType()
        let coordinator = HomeCoordinator(
            router: Router(rootController: self.rootController ?? self.router.asNavigationController),
            factory: HomeBuilder(),
            userType: userType
        )
        coordinator.requestCoordinating = { [weak self, weak coordinator] destination in
            switch destination {
            case .attendance:
                self?.runAttendanceFlow()
            case .setting(let userType):
                self?.runMyPageFlow(of: userType)
            case .signIn:
                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                self?.removeDependency(coordinator)
            case .notification:
                self?.runNotificationFlow()
            case .soptlog:
                self?.tabBarController?.selectedIndex = 1
            case .deepLink(let url):
                self?.notificationHandler.receive(deepLink: url)
                guard let deepLink = self?.notificationHandler.deepLink.value else { return }
                self?.handleDeepLink(deepLink: deepLink)
            case .webLink(let url):
                self?.handleWebLink(webLink: url)
            case .calendar:
                self?.showHomeCalendarDetail()
            }
        }
        addDependency(coordinator)
        coordinator.start()
        return coordinator
    }
    
    
    public func showHomeCalendarDetail() {
        var homeCalendarDetail = HomeBuilder().makeHomeCalendarDetail()
        
        homeCalendarDetail.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
        }
        
        homeCalendarDetail.vm.onAttendanceButtonTap = { [weak self] in
            self?.runAttendanceFlow()
        }
        
        router.push(homeCalendarDetail.vc)
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
            coordinator?.childCoordinators = []
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
        let coordinator = makePokeCoordinator()
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
    @discardableResult
    internal func makePokeCoordinator() -> PokeCoordinator {
        let coordinator = PokeCoordinator(
            router: Router(rootController: UIWindow.getRootNavigationController),
            factory: PokeBuilder()
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        
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
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
    @discardableResult
    internal func runDailySoptuneFlow() -> DailySoptuneCoordinator {
        let coordinator = DailySoptuneCoordinator(
            router: Router(
                rootController: UIWindow.getRootNavigationController
            ),
            factory: DailySoptuneBuilder(), 
            pokeFactory: PokeBuilder()
        )
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        coordinator.requestCoordinating = { [weak self] in
            self?.notificationHandler.receive(deepLink: "home")
            guard let deepLinkComponent = self?.notificationHandler.deepLink.value else { return }
            self?.handleDeepLink(deepLink: deepLinkComponent)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
    @discardableResult
    internal func runSoptlogFlow() -> SoptlogCoordinator {
        let coordinator = SoptlogCoordinator(
            router: Router(rootController: self.rootController ?? self.router.asNavigationController),
            factory: SoptlogBuilder()
        )
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        coordinator.requestCoordinating = { [weak self] destination in
            switch destination {
            case .dailySoptune:
                self?.runDailySoptuneFlow()
            case .signIn:
                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
            case .webLink(let url):
                self?.handleWebLink(webLink: url)
            }
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
}
