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
import HomeFeature
import AppMyPageFeature
import NotificationFeature
import StampFeature
import PokeFeature
import AttendanceFeature
import DailySoptuneFeature
import WebFeature
import SoptlogFeature
import TabBarFeature

public
final class ApplicationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let router: LegacyRouter
    private var cancelBag = CancelBag()
    let notificationHandler: NotificationHandler
    
    internal let rootNavigationController: UINavigationController
    
    private weak var legacyRootController: UINavigationController?
    private let homeNavigationController = UINavigationController()
    private let soptlogNavigationController = UINavigationController()
    weak var tabBarController: UITabBarController?
    
    private weak var homeCoordinator: DefaultHomeCoordinator?
    private weak var soptlogCoordinator: DefaultSoptlogCoordinator?
    
    // MARK: - Init
    
    public init(
        rootNavigationController: UINavigationController,
        router: LegacyRouter,
        notificationHandler: NotificationHandler
    ) {
        self.rootNavigationController = rootNavigationController
        self.router = router
        self.notificationHandler = notificationHandler
        
        super.init()
    }
    
    // MARK: - Coordinator Life Cycle
    
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
    
    // MARK: - bindNotification
    
    private func bindNotification() {
        self.cancelBag.cancel()
        
        self.notificationHandler.deepLink
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is DefaultTabBarCoordinator })
            }
            .sink { [weak self] deepLinkComponent in
                self?.handleDeepLink(deepLink: deepLinkComponent)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
        
        self.notificationHandler.webLink
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is DefaultTabBarCoordinator })
            }.sink { [weak self] url in
                self?.handleWebLink(webLink: url)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
        
        self.notificationHandler.notificationLinkError
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .filter { _ in
                self.childCoordinators.contains(where: { $0 is DefaultTabBarCoordinator })
            }.sink { [weak self] error in
                self?.handleNotificationLinkError(error: error)
                self?.notificationHandler.clearNotificationRecord()
            }.store(in: cancelBag)
    }
    
    // MARK: - handleDeepLink
    
    func handleDeepLink(deepLink: DeepLinkComponentsExecutable) {
        switch Config.coordinatorFlag {
        case .legacy:
            handleLegacyDeepLink(deepLink: deepLink)
        case .new:
            handleNewDeepLink(deepLink: deepLink)
        }
    }
    
    private func handleLegacyDeepLink(deepLink: DeepLinkComponentsExecutable) {
        self.legacyRootController?.dismiss(animated: false)
        deepLink.execute(coordinator: self)
    }
    
    private func handleNewDeepLink(deepLink: DeepLinkComponentsExecutable) {
        self.rootNavigationController.popToRootViewController(animated: false)
        deepLink.execute(coordinator: self)
    }
    
    // MARK: - handleWebLink
    
    func handleWebLink(webLink: String) {
        switch Config.coordinatorFlag {
        case .legacy:
            handleLegacyWebLink(webLink: webLink)
        case .new:
            handleNewWebLink(webLink: webLink)
        }
    }
    
    private func handleLegacyWebLink(webLink: String) {
        self.router.dismissModule(animated: false)
        guard let url = URL(string: webLink) else { return }
        let webView = SOPTWebView(startWith: url)
        router.push(webView)
    }
    
    private func handleNewWebLink(webLink: String) {
        self.rootNavigationController.dismiss(animated: true)
        guard let url = URL(string: webLink) else { return }
        let webView = SOPTWebView(startWith: url)
        CoordinatorUtils.pushOnRootNavigation(webView)
    }
    
    // MARK: - handleNotificationLinkError
    
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
        var coordinator: DefaultCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            let legacyCoordinator = LegacySplashCoordinator(
                router: router,
                factory: LegacySplashBuilder()
            )
            
            legacyCoordinator.finishFlow = { [weak self, weak legacyCoordinator] in
                self?.checkDidSignIn()
                self?.removeDependency(legacyCoordinator
                )
            }
            coordinator = legacyCoordinator
        case .new:
            let newCoordinator = SplashCoordinator(
                navigationController: rootNavigationController,
                factory: SplashBuilder()
            )
            
            newCoordinator.finished = { [weak self] in
                self?.checkDidSignIn()
            }
            
            coordinator = newCoordinator
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func checkDidSignIn() {
        let needAuth = UserDefaultKeyList.Auth.appAccessToken == nil
        needAuth ? runSignInFlow(by: .root) : (Config.coordinatorFlag == .legacy ? runLegacyTabBarFlow() : runTabBarFlow())
    }
}

// MARK: - SignInFlow

extension ApplicationCoordinator {
    func runSignInFlow(by style: CoordinatorStartingOption) {
        let coordinator = AuthCoordinator(router: router, factory: AuthBuilder())
        coordinator.finishFlow = { [weak self, weak coordinator] userType in
            Config.coordinatorFlag == .legacy ? self?.runLegacyTabBarFlow(type: userType) : self?.runTabBarFlow()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(by: style)
    }
    
    private func runSignInSuccessFlow(with url: String) {
        childCoordinators = []
        let coordinator = AuthCoordinator(router: router, factory: AuthBuilder(), url: url)
        coordinator.finishFlow = { [weak self, weak coordinator] userType in
            Config.coordinatorFlag == .legacy ? self?.runLegacyTabBarFlow(type: userType) : self?.runTabBarFlow()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start(by: .rootWindow(animated: false, message: nil))
    }
}

// MARK: - LegacyTabBarFlow

extension ApplicationCoordinator {
    internal func runLegacyTabBarFlow(type: UserType? = nil, initSelectedTabIndex: Int = 0) {
        defer {
            bindNotification()
        }
        
        self.childCoordinators = []
        
        let tabBarBuilder = TabBarBuilder()
        let userType = type ?? UserDefaultKeyList.Auth.getUserType()

        let homeCoordinator = runHomeFlow(type: userType)
        guard let homeVC = homeCoordinator.rootViewController else { return }
    
        let soptlogCoordinator = runSoptlogFlow(type: userType)
        guard let soptlogVC = soptlogCoordinator.rootViewController else { return }
                
        let (tabbarController, viewModel) = tabBarBuilder.makeTabBar(
            with: [homeVC,
                   soptlogVC],
            userType: userType
        )
        
        let coordinator = LegacyTabBarCoordinator(
            router: router,
            factory: (tabbarController, viewModel),
            items: [
                homeVC,
                soptlogVC
            ]
        )
        
        self.legacyRootController = tabbarController.asNavigationController
        self.tabBarController = tabbarController
        
        self.tabBarController?.selectedIndex = initSelectedTabIndex
        
        // 각 코디네이터 실행
        coordinator.requestCoordinating = { [weak self, weak coordinator] destination in
            switch destination {
            case .home:
                self?.homeCoordinator?.requestCoordinating = { [weak self, weak coordinator] destination in
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
                    case .poke(let isNewUser):
                        _ = isNewUser ? self?.runPokeOnboardingFlow() : self?.runPokeFlow()
                    }
                }
            case .soptlog:
                self?.soptlogCoordinator?.requestCoordinating = { [weak self] destination in
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
}

// MARK: - TabBarFlow

extension ApplicationCoordinator {
    internal func runTabBarFlow(type: UserType? = nil, initSelectedTabType: TabType = .home) {
        defer { bindNotification() }
        self.childCoordinators = []
        
        let tabBarBuilder = TabBarBuilder()
        let userType = type ?? UserDefaultKeyList.Auth.getUserType()

        runHomeFlow(type: userType)
        runSoptlogFlow(type: userType)
        
        let tabBarFactory = tabBarBuilder.makeTabBar(
            with: [homeNavigationController, soptlogNavigationController],
            userType: userType
        )
        
        let coordinator = TabBarCoordinator(
            navigationController: rootNavigationController,
            factory: tabBarFactory
        )
        
        coordinator.delegate = self
        self.rootNavigationController.setViewControllers([tabBarFactory.vc], animated: false)
        
        addDependency(coordinator)
        coordinator.start()
    }
}

// MARK: - HomeFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runHomeFlow(type: UserType) -> DefaultHomeCoordinator {
        var coordinator: DefaultHomeCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacyHomeCoordinator(
                router: LegacyRouter(rootController: self.legacyRootController ?? self.router.asNavigationController),
                factory: LegacyHomeBuilder(),
                userType: type
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
                case .poke(let isNewUser):
                    _ = isNewUser ? self?.runPokeOnboardingFlow() : self?.runPokeFlow()
                }
            }
        case .new:
            let newCoordinator = HomeCoordinator(
                navigationController: homeNavigationController,
                factory: HomeBuilder(),
                userType: type
            )
            
            newCoordinator.delegate = self
            coordinator = newCoordinator
        }
        
        addDependency(coordinator)
        coordinator.start()
        return coordinator
    }
}

// MARK: - CalendarDetailFlow

extension ApplicationCoordinator {
    public func showHomeCalendarDetail() {
        switch Config.coordinatorFlag {
        case .legacy: showLegacyHomeCalendarDetail()
        case .new: showNewHomeCalendarDetail()
        }
    }
    
    public func showLegacyHomeCalendarDetail() {
        var homeCalendarDetail = LegacyHomeBuilder().makeHomeCalendarDetail()
        
        homeCalendarDetail.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
        }
        
        homeCalendarDetail.vm.onAttendanceButtonTap = { [weak self] in
            self?.runAttendanceFlow()
        }

        UIWindow.getRootNavigationController.pushViewController(homeCalendarDetail.vc.viewController, animated: true)
    }
    
    public func showNewHomeCalendarDetail() {
        var homeCalendarDetail = HomeBuilder().makeHomeCalendarDetail()
        
        homeCalendarDetail.vm.onNaviBackButtonTap = { [weak self] in
            self?.rootNavigationController.popViewController(animated: true)
        }
        
        homeCalendarDetail.vm.onAttendanceButtonTap = { [weak self] in
            self?.runAttendanceFlow()
        }

        CoordinatorUtils.pushOnRootNavigation(homeCalendarDetail.vc)
    }
}

// MARK: - AttendanceFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runAttendanceFlow() -> DefaultCoordinator {
        var coordinator: DefaultCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacyAttendanceCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyAttendanceBuilder()
            )
        case .new:
            coordinator = AttendanceCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: AttendanceBuilder()
            )
        }
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - StampFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runStampFlow() -> DefaultCoordinator {
        var coordinator: DefaultCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacyStampCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyStampBuilder()
            )
        case .new:
            coordinator = StampCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: StampBuilder()
            )
        }
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - PokeFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runPokeFlow() -> DefaultCoordinator {
        var coordinator = makePokeCoordinator()
        
        addDependency(coordinator)
        coordinator.start()
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        return coordinator
    }
    
    @discardableResult
    internal func makePokeCoordinator() -> DefaultPokeCoordinator {
        var coordinator: DefaultPokeCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacyPokeCoordinator(
                router: LegacyRouter(rootController: UIWindow.getRootNavigationController),
                factory: LegacyPokeBuilder()
            )
        case .new:
            coordinator = PokeCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: PokeBuilder()
            )
        }

        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        
        return coordinator
    }
    
    @discardableResult
    internal func runPokeOnboardingFlow() -> DefaultCoordinator {
        var coordinator: DefaultCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacyPokeOnboardingCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyPokeBuilder()
            )
        case .new:
            coordinator = PokeOnboardingCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: PokeBuilder()
            )
        }

        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
    internal func runPokeNotificationListFlow() -> DefaultCoordinator {
        var coordinator: DefaultCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacyPokeNotificationListCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyPokeBuilder()
            )
        case .new:
            coordinator = PokeNotificationListCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: PokeBuilder()
            )
        }

        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - MyPageFlow

extension ApplicationCoordinator {
    
    @discardableResult
    internal func runMyPageFlow(of userType: UserType) -> DefaultMyPageCoordinator {
        var coordinator: DefaultMyPageCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            let legacyCoordinator = LegacyMyPageCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyMyPageBuilder(),
                userType: userType
            )
            legacyCoordinator.finishFlow = { [weak self, weak legacyCoordinator] in
                self?.removeDependency(legacyCoordinator)
            }
            legacyCoordinator.requestCoordinating = { [weak self, weak legacyCoordinator] destination in
                self?.removeDependency(legacyCoordinator)
                self?.childCoordinators = []
                switch destination {
                case .signIn:
                    self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                case .signInWithToast:
                    self?.runSignInFlow(by: .rootWindow(animated: true, message: I18N.Setting.Withdrawal.withdrawalSuccess))
                }
            }
            coordinator = legacyCoordinator
        case .new:
            let newCoordinator = MyPageCoordinator(
                factory: MyPageBuilder(),
                userType: userType,
                navigationController: UIWindow.getRootNavigationController
            )
            newCoordinator.delegate = self
            coordinator = newCoordinator
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - NotificationFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runNotificationFlow() -> DefaultNotificationCoordinator {
        var coordinator: DefaultNotificationCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            let legacyCoordinator = LegacyNotificationCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyNotificationBuilder()
            )
            
            legacyCoordinator.requestCoordinating = { [weak self] destination in
                switch destination {
                case .deepLink(let url):
                    self?.notificationHandler.receive(deepLink: url)
                case .webLink(let url):
                    self?.notificationHandler.receive(webLink: url)
                }
            }
            
            coordinator = legacyCoordinator
        case .new:
            let newCoordinator = NotificationCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: NotificationBuilder()
            )
            newCoordinator.delegate = self
            coordinator = newCoordinator
        }
        
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
    
}

// MARK: - DailySoptuneFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runDailySoptuneFlow() -> DefaultDailySoptuneCoordinator {
        var coordinator: DefaultDailySoptuneCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacyDailySoptuneCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyDailySoptuneBuilder(),
                pokeFactory: LegacyPokeBuilder()
            )
            coordinator.finishFlow = { [weak self, weak coordinator] in
                coordinator?.childCoordinators = []
                self?.removeDependency(coordinator)
            }
            
            coordinator.requestCoordinating = { [weak self, weak coordinator] in
                self?.router.popToRootModule(animated: true)
                coordinator?.childCoordinators = []
            }
            addDependency(coordinator)
        case .new:
            coordinator = DailySoptuneCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: DailySoptuneBuilder(),
                pokeFactory: PokeBuilder()
            )
        }
        
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - SoptlogFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runSoptlogFlow(type: UserType) -> DefaultSoptlogCoordinator {
        var coordinator: DefaultSoptlogCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator = LegacySoptlogCoordinator(
                router: LegacyRouter(rootController: self.legacyRootController ?? self.router.asNavigationController),
                factory: LegacySoptlogBuilder(),
                userType: type
            )
            
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
        case .new:
            let newCoordinator = SoptlogCoordinator(
                navigationController: soptlogNavigationController,
                factory: SoptlogBuilder(),
                userType: type
            )
            newCoordinator.delegate = self
            coordinator = newCoordinator
        }
            
        coordinator.finishFlow = { [weak self, weak coordinator] in
            coordinator?.childCoordinators = []
            self?.removeDependency(coordinator)
        }
        
        addDependency(coordinator)
        coordinator.start()
        
        return coordinator
    }
}
