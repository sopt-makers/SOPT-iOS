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
import WebFeature
import SoptlogFeature
import TabBarFeature
import SoptletterFeature

public final class ApplicationCoordinator: BaseCoordinator {
    
    // MARK: - Properties

    private var cancelBag = CancelBag()
    let notificationHandler: NotificationHandler

    internal let rootNavigationController: UINavigationController

    let homeNavigationController = UINavigationController()
    let mypageNavigationController = UINavigationController()
    let stampNavigationController = UINavigationController()
    let pokeNavigationController = UINavigationController()
    weak var tabBarController: UITabBarController?
    /// 현재 탭바에 실제로 노출 중인 탭 구성 (tab-app-service 응답에 따라 동적으로 결정됨)
    private(set) var activeTabTypes: [TabBarItemType] = []

    // MARK: - Init
    
    public init(
        rootNavigationController: UINavigationController,
        notificationHandler: NotificationHandler
    ) {
        self.rootNavigationController = rootNavigationController
        self.notificationHandler = notificationHandler

        super.init()
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start(with option: DeepLinkOption?) {
        // AuthCoordinator의 url은 로그인 콜백 전용 - 유니버설 링크 X
        let signInCallbackURL: String? = {
            guard case .signInSuccess(let url) = option else { return nil }
            return url
        }()
        
        DIContainer.shared.register(
            interface: BaseCoordinator.self,
            implement: { [weak self] in
                guard let self else { return }
                    return AuthCoordinator(navigationController: self.rootNavigationController,
                                           factory: AuthBuilder(),
                                           url: signInCallbackURL)
            }
        )
        
        if let option {
            switch option {
            case .signInSuccess(let url):
                runSignInFlow(
                    by: .rootWindow(animated: false, message: nil),
                    with: url
                )
            case .universalWebLink(let url):
                // 링크는 webLink(CurrentValueSubject)에 담아두고 평소대로 부팅합니다.
                // 탭바가 뜬 뒤 bindNotification()이 구독하는 시점에 현재값이 재생되어 웹뷰가 열립니다.
                notificationHandler.receive(webLink: url)
                runSplashFlow()
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
    
    // MARK: - handleDeepLink
    
    func handleDeepLink(deepLink: DeepLinkComponentsExecutable) {
        self.rootNavigationController.popToRootViewController(animated: false)
        deepLink.execute(coordinator: self)
    }

    // MARK: - handleWebLink

    func handleWebLink(webLink: String) {
        self.rootNavigationController.dismiss(animated: true)
        guard let url = URL(string: webLink) else { return }
        let webView = SOPTWebView(startWith: url)
        CoordinatorUtils.pushOnRootNavigation(webView)
    }
    
    // MARK: - handleNotificationLinkError
    
    private func handleNotificationLinkError(error: NotificationLinkError) {
        switch error {
        case NotificationLinkError.linkNotFound:
            AlertUtils.presentAlertVC(type: .information(), title: I18N.DeepLink.updateAlertTitle,
                                      description: I18N.DeepLink.updateAlertDescription)
        case NotificationLinkError.expiredLink:
            AlertUtils.presentAlertVC(type: .information(), title: I18N.DeepLink.expiredLinkTitle,
                                      description: I18N.DeepLink.expiredLinkDesription)
        default:
            break
        }
    }
}

// MARK: - SplashFlow

extension ApplicationCoordinator {
    private func runSplashFlow() {
        let coordinator = SplashCoordinator(
            navigationController: rootNavigationController,
            factory: SplashBuilder()
        )

        coordinator.finished = { [weak self] in
            self?.checkDidSignIn()
        }

        coordinator.start()
    }

    private func checkDidSignIn() {
        if !UserDefaultKeyList.CoreAuth.hasAccessToken() {
            runSignInFlow(by: .root)
        } else {
            Task { [weak self] in
                await self?.runTabBarFlow()
            }
        }
    }
}

// MARK: - SignInFlow

extension ApplicationCoordinator {
    func runSignInFlow(
        by style: CoordinatorStartingOption,
        with url: String? = nil
    ) {
        @Injected var coordinator: BaseCoordinator

        let authCoordinator = coordinator as? AuthCoordinator
        authCoordinator?.delegate = self

        coordinator.start(by: style)
    }
}

// MARK: - TabBarFlow

extension ApplicationCoordinator {
    @MainActor
    internal func runTabBarFlow(type: UserType? = nil, initSelectedTabType: TabBarItemType = .home) async {
        defer { bindNotification() }

        let tabBarBuilder = TabBarBuilder()
        let userType = type ?? UserDefaultKeyList.CoreAuth.getUserType()

        runHomeFlow(type: userType)
        runStampFlow()
        runPokeFlow()

        var candidates: [(type: TabBarItemType, viewController: UIViewController)] = [
            (.home, homeNavigationController)
        ]

        switch userType {
        case .active, .inactive:
            runMyPageTabFlow(type: userType)
            // 콕찌르기/솝탬프는 tab-app-service 응답에 존재할 때만 탭으로 노출됩니다.
            // (실제 포함 여부는 TabBarBuilder가 도메인 계층을 통해 결정합니다)
            candidates += [
                (.soptamp, stampNavigationController),
                (.poke, pokeNavigationController),
                (.mypage, mypageNavigationController)
            ]

        case .visitor:
            // Visitor는 빈 navigation controller 사용 (실제 화면 전환은 TabBarViewModel에서 막음)
            candidates.append((.mypage, UINavigationController()))
        }

        let tabTypes = await tabBarBuilder.resolveActiveTabTypes(candidates: candidates, userType: userType)
        let viewControllers = candidates.filter { tabTypes.contains($0.type) }.map(\.viewController)

        self.activeTabTypes = tabTypes

        let coordinator = TabBarCoordinator(
            navigationController: rootNavigationController,
            factory: tabBarBuilder,
            views: viewControllers,
            tabTypes: tabTypes,
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
        let coordinator = HomeCoordinator(
            navigationController: homeNavigationController,
            factory: HomeBuilder(),
            userType: type
        )
        coordinator.delegate = self

        coordinator.start()
        return coordinator
    }
}

// MARK: - CalendarDetailFlow

extension ApplicationCoordinator {
    public func showHomeCalendarDetail() {
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
    internal func runAttendanceFlow() -> BaseCoordinator {
        let coordinator = AttendanceCoordinator(
            navigationController: UIWindow.getRootNavigationController,
            factory: AttendanceBuilder()
        )

        coordinator.start()

        return coordinator
    }
}

// MARK: - AppServiceFlow
extension ApplicationCoordinator {
    func runAppServiceFlow(_ type: AppServiceType) {
        switch type {
        case .soptletter:
            runSoptletterOnboardingFlow()
        }
    }
}

// MARK: - SoptletterFlow
// TODO: - 솝레터 목록뷰 완성 후 코디네이터 생명주기 관리 필요 (솝레터 메인 뷰모델이 관리)
extension ApplicationCoordinator {
    
    @discardableResult
    internal func runSoptletterOnboardingFlow() -> BaseCoordinator {
        let coordinator = SoptletterCoordinator(
            navigationController: UIWindow.getRootNavigationController,
            factory: SoptletterBuilder()
        )
        coordinator.start()

        return coordinator
    }
    
    // TODO: - soptletter main flow 생성
}

// MARK: - StampFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runStampFlow(isRouteFromTabBar: Bool = true) -> BaseCoordinator {
        let coordinator = StampCoordinator(
            navigationController: stampNavigationController,
            factory: StampBuilder(),
            mypageFactory: MyPageBuilder()
        )
        coordinator.start(isRouteFromTabBar: isRouteFromTabBar)

        return coordinator
    }
}

// MARK: - PokeFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runPokeFlow() -> BaseCoordinator {
        let coordinator = PokeCoordinator(
            navigationController: pokeNavigationController,
            factory: PokeBuilder()
        )
        coordinator.start()

        return coordinator
    }

    @discardableResult
    internal func runPokeOnboardingFlow() -> BaseCoordinator {
        let coordinator = PokeOnboardingCoordinator(
            navigationController: UIWindow.getRootNavigationController,
            factory: PokeBuilder()
        )

        coordinator.start()

        return coordinator
    }

    internal func runPokeNotificationListFlow() -> BaseCoordinator {
        let coordinator = PokeNotificationListCoordinator(
            navigationController: UIWindow.getRootNavigationController,
            factory: PokeBuilder()
        )

        coordinator.start()

        return coordinator
    }
}

// MARK: - MyPageTabFlow

extension ApplicationCoordinator {
    internal func runMyPageTabFlow(type: UserType) {
        let newCoordinator = MyPageCoordinator(
            factory: MyPageBuilder(),
            userType: type,
            navigationController: mypageNavigationController
        )
        newCoordinator.delegate = self
        newCoordinator.onShowSoptlog = { [weak self] in
            self?.pushSoptlogInMyPageTab()
        }
        newCoordinator.start()
    }

    internal func pushSoptlogInMyPageTab() {
        let soptlogCoordinator = SoptlogCoordinator(
            navigationController: mypageNavigationController,
            factory: SoptlogBuilder()
        )
        soptlogCoordinator.delegate = self
        soptlogCoordinator.start()
    }
}

// MARK: - NotificationFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runNotificationFlow(animated: Bool = true) -> BaseCoordinator {
        let coordinator = NotificationCoordinator(
            navigationController: UIWindow.getRootNavigationController,
            factory: NotificationBuilder()
        )
        coordinator.delegate = self

        coordinator.start(animated: animated)

        return coordinator
    }

}

// MARK: - SoptlogFlow

extension ApplicationCoordinator {
    @discardableResult
    internal func runSoptlogFlow(type: UserType) -> BaseCoordinator {
        let coordinator = SoptlogCoordinator(
            navigationController: mypageNavigationController,
            factory: SoptlogBuilder()
        )
        coordinator.delegate = self

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
