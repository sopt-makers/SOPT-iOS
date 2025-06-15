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

public final class MyPageCoordinator: DefaultMyPageCoordinator & MyPageCoordinatable {
    
    // MARK: - Coordinatable
    
    public var onNaviBackButtonTap: (() -> Void)?
    public var onPolicyItemTap: (() -> Void)?
    public var onTermsOfUseItemTap: (() -> Void)?
    public var onEditOnelineSentenceItemTap: (() -> Void)?
    public var onWithdrawalItemTap: ((Core.UserType) -> Void)?
    public var onShowLogin: (() -> Void)?
    public var onShowLogout: (() -> Void)?
    public var onAlertButtonTap: ((String) -> Void)?
    public var onResetSoptampTap: (() -> Void)?
    
    
    // MARK: - Properties
    
    public weak var delegate: MyPageCoordinatorDelegate?
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)?
    
    private let factory: MyPageFeatureBuildable
    private let userType: UserType
    private weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    public init(
        factory: MyPageFeatureBuildable,
        userType: UserType,
        navigationController: UINavigationController
    ) {
        self.factory = factory
        self.userType = userType
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showMyPage()
    }
    
    // MARK: - Navigation
    
    private func showMyPage() {
        let myPage = factory.makeAppMyPage(userType: userType, coordinator: self)
        
        onNaviBackButtonTap = { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        onShowLogout = { [weak self] in
            guard let self = self else { return }
            self.delegate?.myPageCoordinator(self, to: .signIn)
        }
        
        onShowLogin = { [weak self] in
            guard let self = self else { return }
            self.delegate?.myPageCoordinator(self, to: .signIn)
        }
        
        onPolicyItemTap = { [weak self] in
            guard let self = self else { return }
            let policyVC = self.factory.makePrivacyPolicyVC()
            self.navigationController?.pushViewController(policyVC, animated: true)
        }
        
        onTermsOfUseItemTap = { [weak self] in
            guard let self = self else { return }
            let termsVC = self.factory.makeTermsOfServiceVC()
            self.navigationController?.pushViewController(termsVC, animated: true)
        }
        
        onEditOnelineSentenceItemTap = { [weak self] in
            guard let self = self else { return }
            let sentenceEditVC = self.factory.makeSentenceEditVC()
            self.navigationController?.pushViewController(sentenceEditVC, animated: true)
        }
        
        onWithdrawalItemTap = { [weak self] userType in
            self?.showWithdrawal(userType: userType)
        }
        
        onAlertButtonTap = { [weak self] url in
            self?.showAlertSetting(url: url)
        }
        
        self.navigationController?.pushViewController(myPage.vc, animated: true)
    }
    
    private func showWithdrawal(userType: UserType) {
        var withdrawal = factory.makeWithdrawalVC(userType: userType)
        withdrawal.vm.onWithdrawal = { [weak self] in
            guard let self else { return }
            self.delegate?.myPageCoordinator(self, to: .signInWithToast)
        }
        
        self.navigationController?.pushViewController(withdrawal.vc, animated: true)
    }
    
    private func showAlertSetting(url: String) {
        openExternalLink(urlStr: url)
    }
}
