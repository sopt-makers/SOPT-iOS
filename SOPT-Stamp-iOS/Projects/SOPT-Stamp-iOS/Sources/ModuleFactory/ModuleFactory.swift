//
//  ModuleFactory.swift
//  SOPT-Stamp-iOS
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Core
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
    
    public func makeSignInVC() -> Presentation.SignInVC {
        let repository = SignInRepository(service: userService)
        let useCase = DefaultSignInUseCase(repository: repository)
        let viewModel = SignInViewModel(useCase: useCase)
        let signinVC = SignInVC()
        signinVC.factory = self
        signinVC.viewModel = viewModel
        return signinVC
    }
    
    public func makeSignUpVC() -> Presentation.SignUpVC {
        let repository = SignUpRepository(service: authService, userService: userService)
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
    
    public func makeListDetailVC(sceneType: ListDetailSceneType, starLevel: StarViewLevel, missionId: Int, missionTitle: String) -> ListDetailVC {
        let repository = ListDetailRepository(service: stampService)
        let useCase = DefaultListDetailUseCase(repository: repository)
        let viewModel = ListDetailViewModel(useCase: useCase, sceneType: sceneType, starLevel: starLevel, missionId: missionId, missionTitle: missionTitle)
        let listDetailVC = ListDetailVC()
        listDetailVC.viewModel = viewModel
        listDetailVC.factory = self
        return listDetailVC
    }
    
    public func makeMissionCompletedVC(starLevel: StarViewLevel) -> MissionCompletedVC {
        let missionCompletedVC = MissionCompletedVC()
            .setLevel(.levelThree)
        return missionCompletedVC
    }
    
    public func makeAlertVC(title: String, customButtonTitle: String) -> AlertVC {
        let alertVC = AlertVC()
            .setTitle(title)
            .setCustomButtonTitle(customButtonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        return alertVC
    }
    
    public func makeRankingVC() -> RankingVC {
        let repository = RankingRepository(service: rankService)
        let useCase = DefaultRankingUseCase(repository: repository)
        let viewModel = RankingViewModel(useCase: useCase)
        let rankingVC = RankingVC()
        rankingVC.factory = self
        rankingVC.viewModel = viewModel
        return rankingVC
    }
    
    public func makeSettingVC() -> SettingVC {
        let repository = SettingRepository(service: authService)
        let useCase = DefaultSettingUseCase(repository: repository)
        let viewModel = SettingViewModel(useCase: useCase)
        let settingVC = SettingVC()
        settingVC.factory = self
        settingVC.viewModel = viewModel
        return settingVC
    }
    
    public func makePasswordChangeVC() -> PasswordChangeVC {
        let repository = SettingRepository(service: authService)
        let useCase = DefaultPasswordChangeUseCase(repository: repository)
        let viewModel = PasswordChangeViewModel(useCase: useCase)
        let passwordChangeVC = PasswordChangeVC()
        passwordChangeVC.factory = self
        passwordChangeVC.viewModel = viewModel
        return passwordChangeVC
    }
    
    public func makePrivacyPolicyVC() -> Presentation.PrivacyPolicyVC {
        let privacyPolicyVC = PrivacyPolicyVC()
        return privacyPolicyVC
    }
    
    public func makeTermsOfServiceVC() -> Presentation.TermsOfServiceVC {
        let termsOfServiceVC = TermsOfServiceVC()
        return termsOfServiceVC
    }
}
