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
}
public protocol MainCoordinatorOutput {
    var finishFlow: (() -> Void)? { get set }
    var requestCoordinating: ((MainCoordinatorDestination) -> Void)? { get set }
}
public typealias DefaultMainCoordinator = BaseCoordinator & MainCoordinatorOutput

public
final class MainCoordinator: DefaultMainCoordinator {
        
    public var requestCoordinating: ((MainCoordinatorDestination) -> Void)?
    public var finishFlow: (() -> Void)?
    
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
        router.replaceRootWindow(main.vc, withAnimation: true)
    }
}
