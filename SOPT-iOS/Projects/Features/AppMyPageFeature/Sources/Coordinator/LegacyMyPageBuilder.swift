//
//  LegacyMyPageBuilder.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import AppMyPageFeatureInterface

public
final class LegacyMyPageBuilder {
    @Injected public var appMyPageRepository: AppMyPageRepositoryInterface
    @Injected public var settingRepository: SettingRepositoryInterface
    @Injected public var notificationSettingsRepository: NotificationSettingRepositoryInterface
    
    public init() { }
}

extension LegacyMyPageBuilder: LegacyMyPageFeatureBuildable {
    public func makeSentenceEditVC() -> LegacySentenceEditViewControllable {
        let useCase = DefaultSentenceEditUseCase(repository: settingRepository)
        let viewModel = SentenceEditViewModel(useCase: useCase)
        let sentenceEditVC = SentenceEditVC()
        sentenceEditVC.viewModel = viewModel
        return sentenceEditVC
    }

    public func makePrivacyPolicyVC() -> LegacyPrivacyPolicyViewControllable {
        let privacyPolicyVC = PrivacyPolicyVC()
        return privacyPolicyVC
    }

    public func makeTermsOfServiceVC() -> LegacyTermsOfServiceViewControllable {
        let termsOfServiceVC = TermsOfServiceVC()
        return termsOfServiceVC
    }

    public func makeWithdrawalVC(userType: UserType) -> LegacyWithdrawalViewControllable {
        let useCase = DefaultSettingUseCase(repository: settingRepository)
        let viewModel = WithdrawalViewModel(useCase: useCase)
        let withdrawalVC = WithdrawalVC(viewModel: viewModel, userType: userType)
        return withdrawalVC
    }
    
    public func makeAppMyPage(userType: UserType, coordinator: MyPageCoordinatable) -> LegacyMyPagePresentable {
        let useCase = DefaultAppMyPageUseCase(repository: appMyPageRepository)
        let vm = AppMyPageViewModel(useCase: useCase, coordinator: coordinator)
        let vc = AppMyPageVC(userType: userType, viewModel: vm)
        return (vc, vm)
    }
    
    public func makeAlertSettingByFeatures() -> NotificationSettingByFeaturesViewControllable {
        let usecase = DefaultNotificationSettingByFeaturesUsecase(repository: self.notificationSettingsRepository)
        let viewModel = NotificationSettingByFeaturesViewModel(usecase: usecase)
        let vc = NotificationSettingByFeaturesVC(viewModel: viewModel)
        return vc
    }
}
