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

import BaseFeatureDependency
import MainFeatureInterface
import MainFeature
import SplashFeatureInterface
import SplashFeature
import AttendanceFeature
import AttendanceFeatureInterface
import AuthFeatureInterface
import AuthFeature
import SettingFeatureInterface
import SettingFeature
import StampFeatureInterface
import StampFeature
import AppMyPageFeatureInterface
import AppMyPageFeature

typealias Features = SplashFeatureViewBuildable
    & AttendanceFeatureViewBuildable
    & AuthFeatureViewBuildable
    & StampFeatureViewBuildable
    & SettingFeatureViewBuildable
    & MainFeatureViewBuildable
    & AlertViewBuildable

final class DIContainer {
    lazy var attendanceService = DefaultAttendanceService()
    lazy var authService = DefaultAuthService()
    lazy var userService = DefaultUserService()
    lazy var rankService = DefaultRankService()
    lazy var missionService = DefaultMissionService()
    lazy var stampService = DefaultStampService()
    lazy var firebaseService = DefaultFirebaseService()
    lazy var configService = DefaultConfigService()
}

extension DIContainer: Features {
    
    // MARK: - MainFeature
    
    func makeMainVC(userType: Core.UserType) -> MainFeatureInterface.MainViewControllable {
        let repository = MainRepository(userService: userService, configService: configService)
        let useCase = DefaultMainUseCase(repository: repository)
        let viewModel = MainViewModel(useCase: useCase, userType: userType)
        let mainVC = MainVC()
        mainVC.factory = self
        mainVC.viewModel = viewModel
        return mainVC
    }
    
    // MARK: - SplashFeature
    
    func makeSplashVC() -> SplashViewControllable {
        let repository = AppNoticeRepository(service: firebaseService)
        let useCase = DefaultAppNoticeUseCase(repository: repository)
        let viewModel = SplashViewModel(useCase: useCase)
        let splashVC = SplashVC()
        splashVC.factory = self
        splashVC.viewModel = viewModel
        return splashVC
    }
    
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> NoticePopUpViewControllable {
        let noticePopUpVC = NoticePopUpVC()
        noticePopUpVC.setData(type: noticeType, content: content)
        noticePopUpVC.modalPresentationStyle = .overFullScreen
        return noticePopUpVC
    }
    
    // MARK: - StampGuideFeature
    
    func makeStampGuideVC() -> StampGuideViewControllable {
        let stampGuideVC = StampGuideVC()
        return stampGuideVC
    }
    
    // MARK: - AttendanceFeature
    
    func makeShowAttendanceVC() -> ShowAttendanceViewControllable {
        let repository = ShowAttendanceRepository(service: attendanceService)
        let useCase = DefaultShowAttendanceUseCase(repository: repository)
        let viewModel = ShowAttendanceViewModel(useCase: useCase)
        let showAttendanceVC = ShowAttendanceVC(viewModel: viewModel, factory: self)
        return showAttendanceVC
    }
    
    // MARK: - AuthFeature
    
    func makeSignInVC() -> SignInViewControllable {
        let repository = SignInRepository(authService: authService, userService: userService)
        let useCase = DefaultSignInUseCase(repository: repository)
        let viewModel = SignInViewModel(useCase: useCase)
        let signinVC = SignInVC()
        signinVC.factory = self
        signinVC.viewModel = viewModel
        return signinVC
    }
    
    // MARK: - StampFeature
    
    func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListViewControllable {
        let repository = MissionListRepository(missionService: missionService, rankService: rankService)
        let useCase = DefaultMissionListUseCase(repository: repository)
        let viewModel = MissionListViewModel(useCase: useCase, sceneType: sceneType)
        let missionListVC = MissionListVC()
        missionListVC.viewModel = viewModel
        missionListVC.factory = self
        return missionListVC
    }
    
    func makeListDetailVC(sceneType: ListDetailSceneType,
                          starLevel: StarViewLevel,
                          missionId: Int,
                          missionTitle: String,
                          isOtherUser: Bool) -> ListDetailViewControllable {
        let repository = ListDetailRepository(service: stampService)
        let useCase = DefaultListDetailUseCase(repository: repository)
        let viewModel = ListDetailViewModel(useCase: useCase,
                                            sceneType: sceneType,
                                            starLevel: starLevel,
                                            missionId: missionId,
                                            missionTitle: missionTitle,
                                            isOtherUser: isOtherUser)
        let listDetailVC = ListDetailVC()
        listDetailVC.viewModel = viewModel
        listDetailVC.factory = self
        return listDetailVC
    }
    
    func makeMissionCompletedVC(starLevel: StarViewLevel, completionHandler: (() -> Void)?) -> MissionCompletedViewControllable {
        let missionCompletedVC = MissionCompletedVC()
            .setLevel(starLevel)
        missionCompletedVC.completionHandler = completionHandler
        missionCompletedVC.modalPresentationStyle = .overFullScreen
        missionCompletedVC.modalTransitionStyle = .crossDissolve
        return missionCompletedVC
    }
    
    func makeRankingVC() -> RankingViewControllable {
        let repository = RankingRepository(service: rankService)
        let useCase = DefaultRankingUseCase(repository: repository)
        let viewModel = RankingViewModel(useCase: useCase)
        let rankingVC = RankingVC()
        rankingVC.factory = self
        rankingVC.viewModel = viewModel
        return rankingVC
    }
    
    func makeAlertVC(type: AlertType,
                     theme: AlertVC.AlertTheme = .main,
                     title: String,
                     description: String = "",
                     customButtonTitle: String,
                     customAction: (() -> Void)? = nil) -> AlertViewControllable {
        let alertVC = AlertVC(alertType: type, alertTheme: theme)
            .setTitle(title, description)
            .setCustomButtonTitle(customButtonTitle)
        alertVC.customAction = customAction
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        return alertVC
    }
    
    func makeNetworkAlertVC(theme: AlertVC.AlertTheme = .main) -> AlertViewControllable {
        let alertVC = AlertVC(alertType: .networkErr, alertTheme: theme)
            .setTitle(I18N.Default.networkError, I18N.Default.networkErrorDescription)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        return alertVC
    }
    
    // MARK: - SettingFeature
    
    func makeSettingVC() -> SettingViewControllable {
        let repository = SettingRepository(authService: authService, stampService: stampService, userService: userService)
        let useCase = DefaultSettingUseCase(repository: repository)
        let viewModel = SettingViewModel(useCase: useCase)
        let settingVC = SettingVC()
        settingVC.factory = self
        settingVC.viewModel = viewModel
        return settingVC
    }
    
    func makeNicknameEditVC() -> NicknameEditViewControllable {
        let settingRepository = SettingRepository(authService: authService, stampService: stampService, userService: userService)
        let settingUseCase = DefaultSettingUseCase(repository: settingRepository)

        let signUpRepository = SignUpRepository(service: userService)
        let signUpUseCase = DefaultSignUpUseCase(repository: signUpRepository)

        let viewModel = NicknameEditViewModel(nicknameUseCase: signUpUseCase, editPostUseCase: settingUseCase)
        let nicknameEdit = NicknameEditVC()
        nicknameEdit.factory = self
        nicknameEdit.viewModel = viewModel
        return nicknameEdit
    }
    
    func makeSentenceEditVC() -> SentenceEditViewControllable {
        let repository = SettingRepository(authService: authService, stampService: stampService, userService: userService)
        let useCase = DefaultSentenceEditUseCase(repository: repository)
        let viewModel = SentenceEditViewModel(useCase: useCase)
        let sentenceEditVC = SentenceEditVC()
        sentenceEditVC.viewModel = viewModel
        sentenceEditVC.factory = self
        return sentenceEditVC
    }
    
    func makePrivacyPolicyVC() -> PrivacyPolicyViewControllable {
        let privacyPolicyVC = PrivacyPolicyVC()
        return privacyPolicyVC
    }
    
    func makeTermsOfServiceVC() -> TermsOfServiceViewControllable {
        let termsOfServiceVC = TermsOfServiceVC()
        return termsOfServiceVC
    }
    
    func makeWithdrawalVC() -> WithdrawalViewControllable {
        let withdrawalVC = WithdrawalVC()
        let repository = SettingRepository(authService: authService, stampService: stampService, userService: userService)
        let useCase = DefaultSettingUseCase(repository: repository)
        let viewModel = WithdrawalViewModel(useCase: useCase)
        withdrawalVC.viewModel = viewModel
        withdrawalVC.factory = self
        return withdrawalVC
    }
    
    func makeAppMyPageVC() -> AppMyPageViewControllerable {
        let viewModel = AppMyPageViewModel()
        let appMyPageViewController = AppMyPageViewController(viewModel: viewModel)
        
        
        
        return appMyPageViewController
    }
}
