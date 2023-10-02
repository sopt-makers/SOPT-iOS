//
//  MyPageCoordinator.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import AppMyPageFeatureInterface

public enum MyPageCoordinatorDestination {
    case signIn
    case signInWithToast
}
public protocol MyPageCoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
    var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)? { get set }
}
public typealias DefaultMyPageCoordinator = BaseCoordinator & MyPageCoordinatorFinishOutput
public
final class MyPageCoordinator: DefaultMyPageCoordinator {
        
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)?
    
    private let factory: MyPageFeatureBuildable
    private let router: Router
    private let userType: UserType
    
    public init(router: Router, factory: MyPageFeatureBuildable, userType: UserType) {
        self.factory = factory
        self.router = router
        self.userType = userType
    }
    
    public override func start() {
        var myPage = factory.makeAppMyPage(userType: userType)
        myPage.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        myPage.onShowLogin = { [weak self] in
            self?.requestCoordinating?(.signIn)
        }
        myPage.onPolicyItemTap = { [weak self] in
            let policyVC = self?.factory.makePrivacyPolicyVC()
            self?.router.push(policyVC)
        }
        myPage.onTermsOfUseItemTap = { [weak self] in
            let termsVC = self?.factory.makeTermsOfServiceVC()
            self?.router.push(termsVC)
        }
        myPage.onEditNicknameItemTap = { [weak self] in
            let nicknameEditVC = self?.factory.makeNicknameEditVC()
            self?.router.push(nicknameEditVC)
        }
        myPage.onEditOnelineSentenceItemTap = { [weak self] in
            let sentenceEditVC = self?.factory.makeSentenceEditVC()
            self?.router.push(sentenceEditVC)
        }
        myPage.onWithdrawalItemTap = { [weak self] userType in
            self?.showWithdrawal(userType: userType)
        }

        router.push(myPage)
    }
    
    private func showWithdrawal(userType: UserType) {
        var withdrawalVC = self.factory.makeWithdrawalVC(userType: userType)
        withdrawalVC.onWithdrawal = { [weak self] in
            self?.requestCoordinating?(.signInWithToast)
        }
        self.router.push(withdrawalVC)
    }
}
