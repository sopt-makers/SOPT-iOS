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

public
final class LegacyMyPageCoordinator: DefaultMyPageCoordinator & MyPageCoordinatable {
    public var onNaviBackButtonTap: (() -> Void)?
    public var onPolicyItemTap: (() -> Void)?
    public var onTermsOfUseItemTap: (() -> Void)?
    public var onEditOnelineSentenceItemTap: (() -> Void)?
    public var onWithdrawalItemTap: ((Core.UserType) -> Void)?
    public var onShowLogin: (() -> Void)?
    public var onShowLogout: (() -> Void)?
    public var onAlertButtonTap: ((String) -> Void)?
    public var onResetSoptampTap: (() -> Void)?
    
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)?
    
    private let factory: LegacyMyPageFeatureBuildable
    private let router: LegacyRouter
    private let userType: UserType
    
    public init(router: LegacyRouter, factory: LegacyMyPageFeatureBuildable, userType: UserType) {
        self.factory = factory
        self.router = router
        self.userType = userType
    }
    
    public override func start() {
        var myPage = factory.makeAppMyPage(userType: userType, coordinator: self)
        
        onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        
        onShowLogout = { [weak self] in
            self?.requestCoordinating?(.signIn)
        }
        
        onShowLogin = { [weak self] in
            self?.requestCoordinating?(.signIn)
        }
        
        onPolicyItemTap = { [weak self] in
            let policyVC = self?.factory.makePrivacyPolicyVC()
            self?.router.push(policyVC)
        }
        
        onTermsOfUseItemTap = { [weak self] in
            let termsVC = self?.factory.makeTermsOfServiceVC()
            self?.router.push(termsVC)
        }
        
        onEditOnelineSentenceItemTap = { [weak self] in
            let sentenceEditVC = self?.factory.makeSentenceEditVC()
            self?.router.push(sentenceEditVC)
        }
        
        onWithdrawalItemTap = { [weak self] userType in
            self?.showWithdrawal(userType: userType)
        }
        
        onAlertButtonTap = { [weak self] url in
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
