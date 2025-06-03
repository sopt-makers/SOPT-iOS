//
//  MyPageCoordinator.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import AppMyPageFeatureInterface

public protocol MyPageCoordinatorDelegate: AnyObject {
    func myPageCoordinator(_ coordinator: MyPageCoordinator, to destination: MyPageCoordinatorDestination)
}

public
final class MyPageCoordinator: DefaultMyPageCoordinator {
    
    public weak var delegate: MyPageCoordinatorDelegate?
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)?
    
    private let factory: MyPageFeatureBuildable
    private let userType: UserType
    private let navigationController: UINavigationController
    
    public init(
        factory: MyPageFeatureBuildable,
        userType: UserType,
        navigationController: UINavigationController
    ) {
        self.factory = factory
        self.userType = userType
        self.navigationController = navigationController
    }
    
    public override func start() {
        var myPage = factory.makeAppMyPage(userType: userType)
        
        myPage.vm.onNaviBackButtonTap = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.finishFlow?()
        }
        
        myPage.vm.onShowLogout = { [weak self] in
            guard let self = self else { return }
            self.delegate?.myPageCoordinator(self, to: .signIn)
        }
        
        myPage.vm.onShowLogin = { [weak self] in
            guard let self = self else { return }
            self.delegate?.myPageCoordinator(self, to: .signIn)
        }
        
        myPage.vm.onPolicyItemTap = { [weak self] in
            guard let self = self else { return }
            let policyVC = self.factory.makePrivacyPolicyVC()
            self.navigationController.pushViewController(policyVC, animated: true)
        }
        
        myPage.vm.onTermsOfUseItemTap = { [weak self] in
            guard let self = self else { return }
            let termsVC = self.factory.makeTermsOfServiceVC()
            self.navigationController.pushViewController(termsVC, animated: true)
        }
        
        myPage.vm.onEditOnelineSentenceItemTap = { [weak self] in
            guard let self = self else { return }
            let sentenceEditVC = self.factory.makeSentenceEditVC()
            self.navigationController.pushViewController(sentenceEditVC, animated: true)
        }
        
        myPage.vm.onWithdrawalItemTap = { [weak self] userType in
            self?.showWithdrawal(userType: userType)
        }
        
        myPage.vm.onAlertButtonTap = { [weak self] url in
            self?.showAlertSetting(url: url)
        }
        
        self.navigationController.pushViewController(myPage.vc, animated: true)
    }
    
    private func showWithdrawal(userType: UserType) {
        var withdrawal = factory.makeWithdrawalVC(userType: userType)
        withdrawal.vm.onWithdrawal = { [weak self] in
            self?.requestCoordinating?(.signInWithToast)
        }
        
        self.navigationController.pushViewController(withdrawal.vc, animated: true)
    }
    
    private func showAlertSetting(url: String) {
        openExternalLink(urlStr: url)
    }
}
