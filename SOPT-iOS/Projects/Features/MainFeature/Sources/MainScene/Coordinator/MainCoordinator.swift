//
//  MainCoordinator.swift
//  MainFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public enum MainCoordinatorDestination {
    case notification
    case myPage(UserType)
    case attendance
    case stamp
    case poke
    case pokeOnboarding
    case signIn
}
public protocol MainCoordinatorOutput {
    var requestCoordinating: ((MainCoordinatorDestination) -> Void)? { get set }
}
public typealias DefaultMainCoordinator = BaseCoordinator & MainCoordinatorOutput

public
final class MainCoordinator: DefaultMainCoordinator {
        
    public var requestCoordinating: ((MainCoordinatorDestination) -> Void)?
    
    private let factory: MainFeatureViewBuildable
    private let router: Router
    private let userType: UserType
    
    public init(router: Router, factory: MainFeatureViewBuildable, userType: UserType) {
        self.factory = factory
        self.router = router
        self.userType = userType
    }
    
    public override func start() {
        var main = factory.makeMain(userType: userType)
        main.vm.onNoticeButtonTap = { [weak self] in
            self?.requestCoordinating?(.notification)
        }
        main.vm.onMyPageButtonTap = { [weak self] userType in
            self?.requestCoordinating?(.myPage(userType))
        }
        main.vm.onSafari = { [weak self] url in
            self?.router.pushSOPTWebView(url: url)
        }
        main.vm.onNeedSignIn = { [weak self] in
            self?.requestCoordinating?(.signIn)
        }
        main.vm.onSoptamp = { [weak self] in
            self?.requestCoordinating?(.stamp)
        }
        main.vm.onPoke = { [weak self] isFirstVisit in
            if isFirstVisit {
                self?.requestCoordinating?(.pokeOnboarding)
            } else {
                self?.requestCoordinating?(.poke)
            }
        }
        main.vm.onAttendance = { [weak self] in
            self?.requestCoordinating?(.attendance)
        }
        router.replaceRootWindow(main.vc, withAnimation: true)
    }
}
