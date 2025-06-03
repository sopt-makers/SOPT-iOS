//
//  LegacyMyPageCoordinator.swift
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
final class LegacyMyPageCoordinator: DefaultMyPageCoordinator {
    
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)?
    
    private let factory: MyPageFeatureBuildable
    private let router: LegacyRouter
    private let userType: UserType
    
    public init(router: LegacyRouter, factory: MyPageFeatureBuildable, userType: UserType) {
        self.factory = factory
        self.router = router
        self.userType = userType
    }
    
    public override func start() {
        var myPage = factory.makeAppMyPage(userType: userType)
        
        myPage.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        
        myPage.vm.onShowLogout = { [weak self] in
            self?.requestCoordinating?(.signIn)
        }
        
        myPage.vm.onShowLogin = { [weak self] in
            self?.requestCoordinating?(.signIn)
        }
        
        myPage.vm.onPolicyItemTap = { [weak self] in
            let policyVC = self?.factory.makePrivacyPolicyVC()
            self?.router.push(policyVC)
        }
        
        myPage.vm.onTermsOfUseItemTap = { [weak self] in
            let termsVC = self?.factory.makeTermsOfServiceVC()
            self?.router.push(termsVC)
        }
        
        myPage.vm.onEditOnelineSentenceItemTap = { [weak self] in
            let sentenceEditVC = self?.factory.makeSentenceEditVC()
            self?.router.push(sentenceEditVC)
        }
        
        myPage.vm.onWithdrawalItemTap = { [weak self] userType in
            self?.showWithdrawal(userType: userType)
        }
        
        myPage.vm.onAlertButtonTap = { [weak self] url in
            self?.showAlertSetting(url: url)
        }
        
        router.push(myPage.vc)
    }
    
    private func showWithdrawal(userType: UserType) {
        var withdrawalVC = self.factory.makeWithdrawalVC(userType: userType)
        withdrawalVC.onWithdrawal = { [weak self] in
            self?.requestCoordinating?(.signInWithToast)
        }
        self.router.push(withdrawalVC)
    }
    
    private func showAlertSetting(url: String) {
        openExternalLink(urlStr: url)
    }
}
