//
//  MyPageBuilder.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Core
import Domain
@_exported import AppMyPageFeatureInterface

public
final class MyPageBuilder {
    @Injected public var appMyPageRepository: AppMyPageRepositoryInterface
    @Injected public var settingRepository: SettingRepositoryInterface
    
    public init() { }
}

extension MyPageBuilder: MyPageFeatureBuildable {
    public func makeSentenceEditVC() -> UIViewController {
        let useCase = DefaultSentenceEditUseCase(repository: settingRepository)
        let viewModel = SentenceEditViewModel(useCase: useCase)
        let sentenceEditVC = SentenceEditVC()
        sentenceEditVC.viewModel = viewModel
        return sentenceEditVC
    }

    public func makePrivacyPolicyVC() -> UIViewController {
        let privacyPolicyVC = PrivacyPolicyVC()
        return privacyPolicyVC
    }

    public func makeTermsOfServiceVC() -> UIViewController {
        let termsOfServiceVC = TermsOfServiceVC()
        return termsOfServiceVC
    }

    public func makeWithdrawalVC(userType: UserType) -> WithdrawalPresentable {
        let useCase = DefaultSettingUseCase(repository: settingRepository)
        let viewModel = WithdrawalViewModel(useCase: useCase)
        let withdrawalVC = WithdrawalVC(viewModel: viewModel, userType: userType)
        
        return (withdrawalVC, viewModel)
    }
    
    public func makeAppMyPage(userType: UserType, coordinator: MyPageCoordinatable) -> MyPagePresentable {
        let useCase = DefaultAppMyPageUseCase(repository: appMyPageRepository)
        let vm = AppMyPageViewModel(useCase: useCase, coordinator: coordinator)
        let vc = AppMyPageVC(userType: userType, viewModel: vm)
        return (vc, vm)
    }
}
