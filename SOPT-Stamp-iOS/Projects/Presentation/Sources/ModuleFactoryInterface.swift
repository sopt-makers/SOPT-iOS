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
    func makeSplashVC() -> SplashVC
    func makeOnboardingVC() -> OnboardingVC
    func makeSignInVC() -> SignInVC
    func makeSignUpVC() -> SignUpVC
    func makeSignUpCompleteVC() -> SignUpCompleteVC
    func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListVC
    func makeListDetailVC(sceneType: ListDetailSceneType, starLevel: StarViewLevel, missionId: Int, missionTitle: String) -> ListDetailVC
    func makeMissionCompletedVC(starLevel: StarViewLevel) -> MissionCompletedVC
    func makeAlertVC(title: String, customButtonTitle: String) -> AlertVC
    func makeRankingVC() -> RankingVC
    func makeSettingVC() -> SettingVC
    func makePasswordChangeVC() -> PasswordChangeVC
}
