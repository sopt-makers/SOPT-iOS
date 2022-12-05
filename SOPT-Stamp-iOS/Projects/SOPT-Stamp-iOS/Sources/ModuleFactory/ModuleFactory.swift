//
//  ModuleFactory.swift
//  SOPT-Stamp-iOS
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Presentation
import Network
import Domain
import Data

public class ModuleFactory {
    static let shared = ModuleFactory()
    private init() { }
    
    lazy var authService = DefaultAuthService()
    lazy var userService = DefaultUserService()
    lazy var rankService = DefaultRankService()
    lazy var missionService = DefaultMissionService()
    lazy var stampService = DefaultStampService()
}

extension ModuleFactory: ModuleFactoryInterface {
    public func makeSplashVC() -> Presentation.SplashVC {
        let splashVC = SplashVC()
        splashVC.factory = self
        return splashVC
    }
    
    public func makeOnboardingVC() -> Presentation.OnboardingVC {
        let onboardingVC = OnboardingVC()
        onboardingVC.factory = self
        return onboardingVC
    }
    
    public func makeSignUpVC() -> Presentation.SignUpVC {
        let repository = SignUpRepository(service: authService)
        let useCase = DefaultSignUpUseCase(repository: repository)
        let viewModel = SignUpViewModel(useCase: useCase)
        let signUpVC = SignUpVC()
        signUpVC.factory = self
        signUpVC.viewModel = viewModel
        return signUpVC
    }
    
    public func makeSignUpCompleteVC() -> SignUpCompleteVC {
        let signUpCompleteVC = SignUpCompleteVC()
        signUpCompleteVC.factory = self
        return signUpCompleteVC
    }
    
    public func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListVC {
        let repository = MissionListRepository(service: missionService)
        let useCase = DefaultMissionListUseCase(repository: repository)
        let viewModel = MissionListViewModel(useCase: useCase, sceneType: sceneType)
        let missionListVC = MissionListVC()
        missionListVC.factory = self
        missionListVC.viewModel = viewModel
        return missionListVC
    }
}
