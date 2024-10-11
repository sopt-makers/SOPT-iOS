//
//  MyPageBuilder.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import AppMyPageFeatureInterface

public
final class MyPageBuilder {
    @Injected public var appMyPageRepository: AppMyPageRepositoryInterface
    @Injected public var settingRepository: SettingRepositoryInterface
    @Injected public var notificationSettingsRepository: NotificationSettingRepositoryInterface
    
    public init() { }
}

extension MyPageBuilder: MyPageFeatureBuildable {
    public func makeSentenceEditVC() -> SentenceEditViewControllable {
        let useCase = DefaultSentenceEditUseCase(repository: settingRepository)
        let viewModel = SentenceEditViewModel(useCase: useCase)
        let sentenceEditVC = SentenceEditVC()
        sentenceEditVC.viewModel = viewModel
        return sentenceEditVC
    }

    public func makePrivacyPolicyVC() -> PrivacyPolicyViewControllable {
        let privacyPolicyVC = PrivacyPolicyVC()
        return privacyPolicyVC
    }

    public func makeTermsOfServiceVC() -> TermsOfServiceViewControllable {
        let termsOfServiceVC = TermsOfServiceVC()
        return termsOfServiceVC
    }

    public func makeWithdrawalVC(userType: UserType) -> WithdrawalViewControllable {
        let withdrawalVC = WithdrawalVC()
        let useCase = DefaultSettingUseCase(repository: settingRepository)
        let viewModel = WithdrawalViewModel(useCase: useCase)
        withdrawalVC.viewModel = viewModel
        withdrawalVC.userType = userType
        return withdrawalVC
    }
    
    public func makeAppMyPage(userType: UserType) -> MyPageViewControllable {
        let useCase = DefaultAppMyPageUseCase(repository: appMyPageRepository)
        let vm = AppMyPageViewModel(useCase: useCase)
        let vc = AppMyPageVC(userType: userType, viewModel: vm)
        return vc
    }
    
    public func makeAlertSettingByFeatures() -> NotificationSettingByFeaturesViewControllable {
        let usecase = DefaultNotificationSettingByFeaturesUsecase(repository: self.notificationSettingsRepository)
        let viewModel = NotificationSettingByFeaturesViewModel(usecase: usecase)
        let vc = NotificationSettingByFeaturesVC(viewModel: viewModel)
        return vc
    }
}
