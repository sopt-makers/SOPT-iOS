//
//  AppMyPageViewModel.swift
//  AppMypageFeature
//
//  Created by Ian on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Foundation
import Combine
import SafariServices

import Core
import Domain
import AppMyPageFeatureInterface
import BaseFeatureDependency

public final class AppMyPageViewModel: MyPageViewModelType {
    
    // MARK: - Trigger
    
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
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: AppMyPageUseCase
    private let userType: UserType = UserDefaultKeyList.Auth.getUserType()
    
    // MARK: - Inputs
    
    public struct Input {
        let naviBackButtonTapped: Driver<Void>
        let cellTapped: Driver<MyPageItem>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let resetSuccessed = PassthroughSubject<Bool, Never>()
        let deregisterPushTokenSuccess = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
    
    public init(useCase: AppMyPageUseCase, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension AppMyPageViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.naviBackButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTap?()
            }.store(in: cancelBag)
        
        input.cellTapped
            .withUnretained(self)
            .sink { owner, item in
                owner.handleCellTap(item: item)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.useCase
            .resetSuccess
            .asDriver()
            .sink { success in
                if success {
                    output.resetSuccessed.send(success)
                } else {
                    AlertUtils.presentNetworkAlertVC()
                }
            }.store(in: cancelBag)
        
        self.useCase
            .deregisterPushTokenSuccess
            .asDriver()
            .withUnretained(self)
            .sink { owner, success in
                if success {
                    owner.logout()
                    owner.onShowLogin?()
                }
            }.store(in: cancelBag)
    }
    
    private func handleCellTap(item: MyPageItem) {
        switch item.type {
        case .privacyPolicy:
            self.onPolicyItemTap?()
        case .termsOfUse:
            self.onTermsOfUseItemTap?()
        case .sendFeedback:
            openExternalLink(urlStr: ExternalURL.KakaoTalk.serviceProposal)
        case .setNotification:
            self.onAlertButtonTap?(UIApplication.openSettingsURLString)
        case .editOnelineSentence:
            self.onEditOnelineSentenceItemTap?()
        case .resetStamp:
            self.showResetSoptampAlert()
        case .withdrawal:
            self.onWithdrawalItemTap?(userType)
        case .logout:
            self.showLogoutAlert()
        case .login:
            self.onShowLogin?()
        }
    }
}
import WebKit
extension AppMyPageViewModel {
    private func logout() {
        UserDefaultKeyList.clearUserData()
        SFSafariViewController.DataStore.default.clearWebsiteData()
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies({_ in  })
    }
    
    private func showResetSoptampAlert() {
        AlertUtils.presentAlertVC(
            type: .titleDescription,
            theme: .main,
            title: I18N.MyPage.resetMissionTitle,
            description: I18N.MyPage.resetMissionDescription,
            customButtonTitle: I18N.MyPage.reset,
            customAction: { [weak self] in
                self?.useCase.resetStamp()
            },
            animated: true
        )
    }
    
    private func showLogoutAlert() {
        AlertUtils.presentAlertVC(
            type: .titleDescription,
            theme: .main,
            title: I18N.MyPage.logoutDialogTitle,
            description: I18N.MyPage.logoutDialogDescription,
            customButtonTitle: I18N.MyPage.logoutDialogGrantButtonTitle,
            customAction: { [weak self] in
                self?.useCase.deregisterPushToken()
                self?.onShowLogout?()
            },
            animated: true
        )
    }
}
