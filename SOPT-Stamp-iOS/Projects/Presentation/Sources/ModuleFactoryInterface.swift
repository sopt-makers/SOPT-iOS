//
//  ModuleFactoryInterface.swift
//  Presentation
//
//  Created by 양수빈 on 2022/10/07.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Core

public protocol ModuleFactoryInterface {
    
    // MARK: - Onboarding / Auth
    func makeSplashVC() -> SplashVC
    func makeOnboardingVC() -> OnboardingVC
    func makeSignInVC() -> SignInVC
    func makeFindAccountVC() -> FindAccountVC
    func makeSignUpVC() -> SignUpVC
    func makeSignUpCompleteVC() -> SignUpCompleteVC
    
    // MARK: - Main Flow
    
    func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListVC
    func makeListDetailVC(sceneType: ListDetailSceneType, starLevel: StarViewLevel, missionId: Int, missionTitle: String) -> ListDetailVC
    func makeMissionCompletedVC(starLevel: StarViewLevel) -> MissionCompletedVC
    func makeRankingVC() -> RankingVC
    
    // MARK: - Settings
    
    func makeSettingVC() -> SettingVC
    func makePasswordChangeVC() -> PasswordChangeVC
    func makeSentenceEditVC() -> SentenceEditVC
    func makeNicknameEditVC() -> NicknameEditVC
    func makePrivacyPolicyVC() -> PrivacyPolicyVC
    func makeTermsOfServiceVC() -> TermsOfServiceVC
    
    // MARK: - Utility
    
    func makeAlertVC(type: AlertType, title: String, description: String, customButtonTitle: String) -> AlertVC
    func makeNetworkAlertVC() -> AlertVC
}
