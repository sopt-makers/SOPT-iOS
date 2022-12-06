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
    func makeSignUpVC() -> SignUpVC
    func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListVC
    func makeListDetailVC(sceneType: ListDetailSceneType, starLevel: StarViewLevel) -> ListDetailVC
    func makeRankingVC() -> RankingVC
}
