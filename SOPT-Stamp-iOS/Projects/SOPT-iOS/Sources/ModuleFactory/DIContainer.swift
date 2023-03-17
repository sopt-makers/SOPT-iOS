//
//  DIContainer.swift
//  SOPT-iOS
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Network
import Domain
import Data

import SplashFeatureInterface
import SplashFeature
import OnboardingFeatureInterface
import OnboardingFeature
import AuthFeatureInterface
import AuthFeature
import StampFeatureInterface
import StampFeature

typealias Features = SplashFeature & OnboardingFeature & AuthFeature & StampFeature

final class DIContainer {
    lazy var authService = DefaultAuthService()
    lazy var userService = DefaultUserService()
    lazy var rankService = DefaultRankService()
    lazy var missionService = DefaultMissionService()
    lazy var stampService = DefaultStampService()
    lazy var firebaseService = DefaultFirebaseService()
}

extension DIContainer: Features {
    
    // MARK: - SplashFeature
    
    func makeSplashVC() -> SplashFeatureInterface {
        let repository = AppNoticeRepository(service: firebaseService)
        let useCase = DefaultAppNoticeUseCase(repository: repository)
        let viewModel = SplashViewModel(useCase: useCase)
        let splashVC = SplashVC()
        splashVC.factory = self
        splashVC.viewModel = viewModel
        return splashVC
    }
    
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> SplashFeatureInterface {
        let noticePopUpVC = NoticePopUpVC()
        noticePopUpVC.setData(type: noticeType, content: content)
        noticePopUpVC.modalPresentationStyle = .overFullScreen
        return noticePopUpVC
    }
    
    // MARK: - OnboardingFeature
    
    func makeOnboardingVC() -> OnboardingFeatureInterface {
        let onboardingVC = OnboardingVC()
        onboardingVC.factory = self
        return onboardingVC
    }
    
    // MARK: - AuthFeature
    
    func makeSignInVC() -> AuthFeatureInterface {
        let repository = SignInRepository(service: userService)
        let useCase = DefaultSignInUseCase(repository: repository)
        let viewModel = SignInViewModel(useCase: useCase)
        let signinVC = SignInVC()
        signinVC.factory = self
        signinVC.viewModel = viewModel
        return signinVC
    }
    
    // MARK: - StampFeature
    
    func makeMissionListVC(sceneType: MissionListSceneType) -> StampFeatureInterface {
        let repository = MissionListRepository(service: missionService)
        let useCase = DefaultMissionListUseCase(repository: repository)
        let viewModel = MissionListViewModel(useCase: useCase, sceneType: sceneType)
        let missionListVC = MissionListVC()
        missionListVC.factory = self
        missionListVC.viewModel = viewModel
        return missionListVC
    }
}
