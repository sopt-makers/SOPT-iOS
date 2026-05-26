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
import LegacyAuthFeature
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
import SoptletterFeature

public final class ApplicationCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let router: LegacyRouter
    private var cancelBag = CancelBag()
    let notificationHandler: NotificationHandler
    
    internal let rootNavigationController: UINavigationController
    
    private weak var legacyRootController: UINavigationController?
    let homeNavigationController = UINavigationController()
    let soptlogNavigationController = UINavigationController()
    let stampNavigationController = UINavigationController()
    let pokeNavigationController = UINavigationController()
    weak var tabBarController: UITabBarController?
    
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
        
        DIContainer.shared.register(
            interface: DefaultAuthCoordinator.self,
            implement: { [weak self] in
                guard let self else { return }
                switch FeatureFlag.auth {
                case .legacy:
                    return LegacyAuthCoordinator(router: self.router, factory: LegacyAuthBuilder(), url: option?.url)
                case .new:
                    return AuthCoordinator(navigationController: self.rootNavigationController,
                                           factory: AuthBuilder(),
                                           url: option?.url)
                }
            }
        )
        
        if let option {
            switch option {
            case .signInSuccess(let url):
                runSignInFlow(
                    by: .rootWindow(animated: false, message: nil),
                    with: url
                )
            }
        } else {
            runSplashFlow()
        }
    }
    
    // MARK: - bindNotification
    
    private func bindNotification() {
        self.cancelBag.cancel()
        
        switch Config.coordinatorFlag {
        case .legacy:
            self.notificationHandler.deepLink
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .filter{ _ in
                    self.childCoordinators.contains(where: { $0 is DefaultTabBarCoordinator })
                }
                .sink { [weak self] deepLinkComponent in
                    self?.handleDeepLink(deepLink: deepLinkComponent)
                    self?.notificationHandler.clearNotificationRecord()
                }.store(in: cancelBag)
            
            self.notificationHandler.webLink
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .filter{ _ in
                    self.childCoordinators.contains(where: { $0 is DefaultTabBarCoordinator })
                }
                .sink { [weak self] url in
                    self?.handleWebLink(webLink: url)
                    self?.notificationHandler.clearNotificationRecord()
                }.store(in: cancelBag)
            
            self.notificationHandler.notificationLinkError
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .filter{ _ in
                    self.childCoordinators.contains(where: { $0 is DefaultTabBarCoordinator })
                }
                .sink { [weak self] error in
                    self?.handleNotificationLinkError(error: error)
                    self?.notificationHandler.clearNotificationRecord()
                }.store(in: cancelBag)
        case .new:
            self.notificationHandler.deepLink
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] deepLinkComponent in
                    self?.handleDeepLink(deepLink: deepLinkComponent)
                    self?.notificationHandler.clearNotificationRecord()
                }.store(in: cancelBag)
            
            self.notificationHandler.webLink
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] url in
                    self?.handleWebLink(webLink: url)
                    self?.notificationHandler.clearNotificationRecord()
                }.store(in: cancelBag)
            
            self.notificationHandler.notificationLinkError
                .compactMap { $0 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] error in
                    self?.handleNotificationLinkError(error: error)
                    self?.notificationHandler.clearNotificationRecord()
                }.store(in: cancelBag)
        }
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
        if let targetTap = deepLink.targetTap {
            tabBarController?.selectedIndex = targetTap.getTabIndex(userType: UserDefaultKeyList.Auth.getUserType())
        }
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
        var coordinator: BaseCoordinator
        
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
            addDependency(legacyCoordinator)
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
        
        coordinator.start()
    }
    
    private func checkDidSignIn() {
        if !UserDefaultKeyList.Auth.hasAccessToken() {
            runSignInFlow(by: .root)
        } else {
            Config.coordinatorFlag == .legacy
            ? runLegacyTabBarFlow()
            : runTabBarFlow()
        }
    }
}

// MARK: - SignInFlow

extension ApplicationCoordinator {
    func runSignInFlow(
        by style: CoordinatorStartingOption,
        with url: String? = nil
    ) {
        @Injected var coordinator: DefaultAuthCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator.finishFlow = { [weak self, weak coordinator] userType in
                Config.coordinatorFlag == .legacy
                ? self?.runLegacyTabBarFlow(type: userType)
                : self?.runTabBarFlow(type: userType)
                self?.removeDependency(coordinator)
            }
            addDependency(coordinator)
        case .new:
            let coordinator = coordinator as? AuthCoordinator
            coordinator?.delegate = self
        }
        
        coordinator.start(by: style)
    }
    
    private func runSignInSuccessFlow(with url: String) {
        childCoordinators = []
        @Injected var coordinator: DefaultAuthCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            coordinator.finishFlow = { [weak self, weak coordinator] userType in
                Config.coordinatorFlag == .legacy
                ? self?.runLegacyTabBarFlow(type: userType)
                : self?.runTabBarFlow(type: userType)
                self?.removeDependency(coordinator)
            }
            addDependency(coordinator)
        case .new:
            let coordinator = coordinator as? AuthCoordinator
            coordinator?.delegate = self
        }
        
        coordinator.start(by: .rootWindow(animated: false, message: nil))
    }
}

// MARK: - LegacyTabBarFlow

extension ApplicationCoordinator {
    internal func runLegacyTabBarFlow(type: UserType? = nil, initSelectedTabIndex: Int = 0) {
//        defer {
//            bindNotification()
//        }
//        
//        self.childCoordinators = []
//        
//        let tabBarBuilder = TabBarBuilder()
//        let userType = type ?? UserDefaultKeyList.Auth.getUserType()
//
//        let homeCoordinator = runHomeFlow(type: userType)
//        guard let homeVC = homeCoordinator.rootViewController else { return }
//    
//        let soptlogCoordinator = runSoptlogFlow(type: userType)
//        guard let soptlogVC = soptlogCoordinator.rootViewController else { return }
//                
//        let (tabbarController, viewModel) = tabBarBuilder.makeTabBar(
//            with: [homeVC,
//                   soptlogVC],
//            userType: userType
//        )
//        
//        let coordinator = LegacyTabBarCoordinator(
//            router: router,
//            factory: (tabbarController, viewModel),
//            items: [
//                homeVC,
//                soptlogVC
//            ]
//        )
//        
//        self.legacyRootController = tabbarController.asNavigationController
//        self.tabBarController = tabbarController
//        
//        self.tabBarController?.selectedIndex = initSelectedTabIndex
//        
//        // 각 코디네이터 실행
//        coordinator.requestCoordinating = { [weak self, weak coordinator] destination in
//            switch destination {
//            case .home:
//                self?.homeCoordinator?.requestCoordinating = { [weak self, weak coordinator] destination in
//                    switch destination {
//                    case .attendance:
//                        self?.runAttendanceFlow()
//                    case .setting(let userType):
//                        self?.runMyPageFlow(of: userType)
//                    case .signIn:
//                        self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
//                        self?.removeDependency(coordinator)
//                    case .notification:
//                        self?.runNotificationFlow()
//                    case .soptlog:
//                        self?.tabBarController?.selectedIndex = 1
//                    case .deepLink(let url):
//                        self?.notificationHandler.receive(deepLink: url)
//                        guard let deepLink = self?.notificationHandler.deepLink.value else { return }
//                        self?.handleDeepLink(deepLink: deepLink)
//                    case .webLink(let url):
//                        self?.handleWebLink(webLink: url)
//                    case .calendar:
//                        self?.showHomeCalendarDetail()
//                    case .poke(let isNewUser):
//                        _ = isNewUser ? self?.runPokeOnboardingFlow() : self?.runPokeFlow()
//                    }
//                }
//            case .soptlog:
//                self?.soptlogCoordinator?.requestCoordinating = { [weak self] destination in
//                    switch destination {
//                    case .dailySoptune:
//                        self?.runDailySoptuneFlow()
//                    case .webLink(let url):
//                        self?.handleWebLink(webLink: url)
//                    }
//                }
//            case .signIn:
//                self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
//                self?.removeDependency(coordinator)
//            }
//        }
//        
//        addDependency(coordinator)
//        coordinator.start()
    }
}

// MARK: - TabBarFlow

extension ApplicationCoordinator {
    internal func runTabBarFlow(type: UserType? = nil, initSelectedTabType: TabBarItemType = .home) {
        defer { bindNotification() }
        
        let tabBarBuilder = TabBarBuilder()
        let userType = type ?? UserDefaultKeyList.Auth.getUserType()
        var viewControllers: [UINavigationController] = []

        runHomeFlow(type: userType)
        runStampFlow()
        runPokeFlow()
        
        switch userType {
        case .active, .inactive:
            runSoptlogFlow(type: userType)
            viewControllers = [
                homeNavigationController,
                stampNavigationController,
                pokeNavigationController,
                soptlogNavigationController
            ]

        case .visitor:
            // Visitor는 빈 navigation controller 사용 (실제 화면 전환은 TabBarViewModel에서 막음)
            viewControllers = [
                homeNavigationController,
                UINavigationController()
            ]
        }

        let coordinator = TabBarCoordinator(
            navigationController: rootNavigationController,
            factory: tabBarBuilder,
            views: viewControllers,
            userType: userType,
            selectedTabType: initSelectedTabType
        )
        coordinator.delegate = self
        coordinator.start()
        
        
        self.tabBarController = coordinator.tabBarController
    }
}

// MARK: - HomeFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runHomeFlow(type: UserType) -> BaseCoordinator {
        var coordinator: BaseCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            let legacyCoordinator = LegacyHomeCoordinator(
                router: LegacyRouter(rootController: self.legacyRootController ?? self.router.asNavigationController),
                factory: LegacyHomeBuilder(),
                userType: type
            )
            
            legacyCoordinator.requestCoordinating = { [weak self, weak legacyCoordinator] destination in
                switch destination {
                case .attendance:
                    self?.runAttendanceFlow()
                case .setting(let userType):
                    self?.runMyPageFlow(of: userType)
                case .signIn:
                    self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                    self?.removeDependency(legacyCoordinator)
                case .notification:
                    self?.runNotificationFlow()
                case .soptlog:
                    self?.tabBarController?.selectedIndex = 3
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
            addDependency(legacyCoordinator)
            coordinator = legacyCoordinator
        case .new:
            let newCoordinator = HomeCoordinator(
                navigationController: homeNavigationController,
                factory: HomeBuilder(),
                userType: type
            )
            newCoordinator.delegate = self
            coordinator = newCoordinator
        }
        
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
            coordinator.finishFlow = { [weak self, weak coordinator] in
                coordinator?.childCoordinators = []
                self?.removeDependency(coordinator)
            }
            addDependency(coordinator)
        case .new:
            coordinator = AttendanceCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: AttendanceBuilder()
            )
        }
        
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - SoptletterFlow
// TODO: - 솝레터 목록뷰 완성 후 코디네이터 생명주기 관리 필요 (솝레터 메인 뷰모델이 관리)
extension ApplicationCoordinator {
    internal func runSoptletterWritingFlow() {
        let coordinator = SoptletterCoordinator(
            navigationController: UIWindow.getRootNavigationController,
            factory: SoptletterBuilder()
        )
        coordinator.start()
    }
}

// MARK: - StampFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runStampFlow(isRouteFromTabBar: Bool = true) -> BaseCoordinator {
        var coordinator: BaseCoordinator

        switch Config.coordinatorFlag {
        case .legacy:
            let legacyStampCoordinator = LegacyStampCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyStampBuilder()
            )
            legacyStampCoordinator.finishFlow = { [weak self, weak legacyStampCoordinator] in
                legacyStampCoordinator?.childCoordinators = []
                self?.removeDependency(legacyStampCoordinator)
            }
            addDependency(legacyStampCoordinator)
            coordinator = legacyStampCoordinator
            coordinator.start()

        case .new:
            let newCoordinator = StampCoordinator(
                navigationController: stampNavigationController,
                factory: StampBuilder(),
                mypageFactory: MyPageBuilder()
            )
            newCoordinator.start(isRouteFromTabBar: isRouteFromTabBar)
            coordinator = newCoordinator
        }

        return coordinator
    }
}

// MARK: - PokeFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runPokeFlow() -> BaseCoordinator {
        var coordinator: BaseCoordinator

        switch Config.coordinatorFlag {
        case .legacy:
            let legacyPokeCoordinator = LegacyPokeCoordinator(
                router: LegacyRouter(rootController: UIWindow.getRootNavigationController),
                factory: LegacyPokeBuilder()
            )

            legacyPokeCoordinator.finishFlow = { [weak self, weak legacyPokeCoordinator] in
                legacyPokeCoordinator?.childCoordinators = []
                self?.removeDependency(legacyPokeCoordinator)
            }
            coordinator = legacyPokeCoordinator
            addDependency(coordinator)

            coordinator.start()
        case .new:
            let newCoordinator = PokeCoordinator(
                navigationController: pokeNavigationController,
                factory: PokeBuilder()
            )
            newCoordinator.start()            
            coordinator = newCoordinator
        }
        
        return coordinator
    }
    
    @discardableResult
    internal func runPokeOnboardingFlow() -> DefaultCoordinator {
        var coordinator: DefaultCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            let legacyCoordinator = LegacyPokeOnboardingCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyPokeBuilder()
            )

            legacyCoordinator.finishFlow = { [weak self, weak legacyCoordinator] in
                legacyCoordinator?.childCoordinators = []
                self?.removeDependency(legacyCoordinator)
            }
            addDependency(legacyCoordinator)
            coordinator = legacyCoordinator
        case .new:
            let newCoordinator = PokeOnboardingCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: PokeBuilder()
            )
            coordinator = newCoordinator
        }
        
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
            addDependency(coordinator)
            coordinator.finishFlow = { [weak self, weak coordinator] in
                coordinator?.childCoordinators = []
                self?.removeDependency(coordinator)
            }
        case .new:
            coordinator = PokeNotificationListCoordinator(
                navigationController: UIWindow.getRootNavigationController,
                factory: PokeBuilder()
            )
        }
        
        
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - MyPageFlow

extension ApplicationCoordinator {
    
    @discardableResult
    internal func runMyPageFlow(of userType: UserType) -> BaseCoordinator {
        var coordinator: BaseCoordinator
        
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
            addDependency(coordinator)
        case .new:
            let newCoordinator = MyPageCoordinator(
                factory: MyPageBuilder(),
                userType: userType,
                navigationController: UIWindow.getRootNavigationController
            )
            newCoordinator.delegate = self
            coordinator = newCoordinator
        }
        
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - NotificationFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runNotificationFlow() -> BaseCoordinator {
        var coordinator: BaseCoordinator
        
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
            
            addDependency(legacyCoordinator)
            legacyCoordinator.finishFlow = { [weak self, weak legacyCoordinator] in
                legacyCoordinator?.childCoordinators = []
                self?.removeDependency(legacyCoordinator)
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
        
        coordinator.start()
        
        return coordinator
    }
    
}

// MARK: - DailySoptuneFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runDailySoptuneFlow() -> BaseCoordinator {
        var coordinator: BaseCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            let legacyCoordinator = LegacyDailySoptuneCoordinator(
                router: LegacyRouter(
                    rootController: UIWindow.getRootNavigationController
                ),
                factory: LegacyDailySoptuneBuilder(),
                pokeFactory: LegacyPokeBuilder()
            )
            legacyCoordinator.finishFlow = { [weak self, weak legacyCoordinator] in
                legacyCoordinator?.childCoordinators = []
                self?.removeDependency(legacyCoordinator)
            }
            
            legacyCoordinator.requestCoordinating = { [weak self, weak legacyCoordinator] in
                self?.router.popToRootModule(animated: true)
                legacyCoordinator?.childCoordinators = []
            }
            coordinator = legacyCoordinator
            addDependency(legacyCoordinator)
            
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
    internal func runSoptlogFlow(type: UserType) -> BaseCoordinator {
        var coordinator: BaseCoordinator
        
        switch Config.coordinatorFlag {
        case .legacy:
            let legacyCoordinator = LegacySoptlogCoordinator(
                router: LegacyRouter(rootController: self.legacyRootController ?? self.router.asNavigationController),
                factory: LegacySoptlogBuilder(),
                userType: type
            )
            
            legacyCoordinator.requestCoordinating = { [weak self] destination in
                switch destination {
                case .dailySoptune:
                    self?.runDailySoptuneFlow()
                case .webLink(let url):
                    self?.handleWebLink(webLink: url)
                case .home:
                    self?.tabBarController?.selectedIndex = 0
                case .signIn:
                    self?.runSignInFlow(by: .rootWindow(animated: true, message: nil))
                    self?.removeDependency(legacyCoordinator)
                default:
                    return
                }
            }
            
            legacyCoordinator.finishFlow = { [weak self, weak legacyCoordinator] in
                legacyCoordinator?.childCoordinators = []
                self?.removeDependency(legacyCoordinator)
            }
            
            addDependency(legacyCoordinator)
            coordinator = legacyCoordinator
        case .new:
            let newCoordinator = SoptlogCoordinator(
                navigationController: soptlogNavigationController,
                factory: SoptlogBuilder()
            )
            newCoordinator.delegate = self
            coordinator = newCoordinator
        }
        
        coordinator.start()
        
        return coordinator
    }
}

// MARK: - PokeTabFlow

extension ApplicationCoordinator {
    internal func runPokeMyFriendsFlow(relation: PokeRelation) {
        self.pokeNavigationController.popToRootViewController(animated: false)
        
        let pokeMyFriendsCoordinator = PokeMyFriendsCoordinator(
            navigationController: self.pokeNavigationController,
            factory: PokeBuilder()
        )
        
        pokeMyFriendsCoordinator.start(with: relation)
    }
}

