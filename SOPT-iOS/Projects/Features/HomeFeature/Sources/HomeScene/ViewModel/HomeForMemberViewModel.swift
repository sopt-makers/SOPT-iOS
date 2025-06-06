//
//  HomeForMemberViewModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.


import Foundation
import Combine
import UserNotifications

import Core
import Domain
import DSKit

import HomeFeatureInterface
import BaseFeatureDependency

public class HomeForMemberViewModel: HomeForMemberViewModelType {
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private var cancelBag = CancelBag()
    
    let userType: UserType = UserDefaultKeyList.Auth.getUserType()
    private var floatingButtonUrl: String = ""
    private var surveyButtonURL: String = ""
    
    let productServiceList: [HomePresentationModel.ProductService] = [
        .init(product: .playgroundCommunity),
        .init(product: .group),
        .init(product: .member),
        .init(product: .project)
    ]
    
    let socialLinkList: [HomePresentationModel.SocialLink] = [
        .init(socialLink: .officialHomepage),
        .init(socialLink: .instagram),
        .init(socialLink: .youtube)
    ]
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let viewWillAppear: Driver<Void>
        let cellTapped: Driver<HomeForMemberItem>
        let attendanceButtonTapped: Driver<Void>
        let noticeButtonTapped: Driver<Void>
        let settingButtonTapped: Driver<Void>
        let extendedFloatingButtonTapped: Driver<Void>
        let surveyButtonTapped: Driver<Void>
        let socialLinkButtonTapped: Driver<HomePresentationModel.SocialLink>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let homeItem = PassthroughSubject<HomePresentationModel, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
        let floatingButtonInfo = PassthroughSubject<HomeFloatingButtonPresentationModel, Never>()
    }
    
    // MARK: - HomeForMemberCoordinating
    
    public var onDashBoardCellTapped: (() -> Void)?
    public var onCalendarCellTapped: (() -> Void)?
    public var onAttendanceButtonTapped: (() -> Void)?
    public var onMainProductCellTapped: ((String) -> Void)?
    public var onAppServiceCellTapped: ((String) -> Void)?
    public var onNotificationButtonTapped: (() -> Void)?
    public var onSettingButtonTapped: ((UserType) -> Void)?
    public var onNeedSignIn: (() -> Void)?
    public var onNetworkError: (() -> Void)?
    public var onPoke: ((Bool) -> Void)?
    public var onExtendedFloatingButtonTapped: ((String) -> Void)?
    public var onSurveyButtonTapped: ((String) -> Void)?
    public var onSocialLinkButtonTapped: ((String) -> Void)?
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeForMemberViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getReportURL()
                owner.requestAuthorizationForNotification()
                AmplitudeInstance.shared.trackWithUserType(event: .viewAppHomeNew)
            }.store(in: cancelBag)
        
        input.viewDidLoad
            .flatMap(useCase.getFloatingButtonInfo)
            .filter{ $0.isActive }
            .withUnretained(self)
            .sink { owner, floatingButtonModel in
                let presentationModel = floatingButtonModel.toPresentationModel()
                output.floatingButtonInfo.send(presentationModel)
                owner.floatingButtonUrl = presentationModel.url
            }.store(in: cancelBag)
        
        input.viewWillAppear
            .handleEvents(receiveOutput: { _ in
                output.isLoading.send(true)
            })
            .flatMap { _ in
                self.useCase.getUserInfo()
                    .catch{ mainError -> AnyPublisher<UserMainInfoModel?, Never> in
                        switch mainError {
                        case .networkError(_):
                            self.onNetworkError?()
                            return Empty().eraseToAnyPublisher()
                        case .authFailed:
                            self.onNeedSignIn?()
                            return Empty().eraseToAnyPublisher()
                        }
                    }
            }
            .compactMap { $0 }
            .withUnretained(self)
            .flatMap { owner, userInfo in
                let dashBoardPublisher = owner.useCase.getHomeDescription()
                    .map { $0.toPresentation(history: userInfo.historyList, isAllConfirm: userInfo.isAllConfirm) }
                
                let recentSchedulePublisher = owner.useCase.getRecentSchedule()
                    .map { $0.toPresentation() }
                
                let appServicePublisher = owner.useCase.getAppServices()
                    .map { $0.map { $0.toPresentation() } }
                
                let playgroundPublisher = owner.useCase.getPlaygroundNewsPosts()
                    .map { $0.map { $0.toPresentation() } }
                
                return Publishers.Zip4(dashBoardPublisher, recentSchedulePublisher, appServicePublisher, playgroundPublisher)
            }
            .flatMap { dashBoard, recentSchedule, appServices, playgroundNewsPosts in
                self.useCase.getSurveyInfo()
                    .map { survey in
                        HomePresentationModel(
                            dashBoard: dashBoard,
                            recentSchedule: recentSchedule,
                            appServices: appServices,
                            playgroundNewsPosts: playgroundNewsPosts,
                            survey: survey.toPresentation()
                        )
                    }
            }
            .withUnretained(self)
            .sink { owner, data in
                owner.surveyButtonURL = data.survey.linkURL
                output.homeItem.send(data)
                output.isLoading.send(false)
            }
            .store(in: cancelBag)
        
        input.cellTapped
            .withUnretained(self)
            .sink { owner, item in
                switch item {
                case .dashBoard:
                    owner.onDashBoardCellTapped?()
                case .recentSchedule:
                    owner.onCalendarCellTapped?()
                    AmplitudeInstance.shared.trackWithUserType(event: .clickAllCalendar)
                case .productService(let model):
                    owner.onMainProductCellTapped?(model.product.serviceDomainLink)
                    owner.trackAmplitude(event: model.product.toAmplitudeEventTypeNew)
                case .appService(let model):
                    if model.serviceName == "콕찌르기" {
                        owner.useCase.checkPokeNewUser()
                            .sink { isPokeNewUser in
                                owner.onPoke?(isPokeNewUser)
                            }.store(in: cancelBag)
                    } else {
                        owner.onAppServiceCellTapped?(model.deepLink)
                    }
                case .socialLink(let type):
                    owner.onSocialLinkButtonTapped?(type.socialLink.serviceDomainLink)
                default: break
                }
            }
            .store(in: cancelBag)
        
        input.noticeButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNotificationButtonTapped?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickAlarmNew)
            }
            .store(in: cancelBag)
        
        input.settingButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSettingButtonTapped?(owner.userType)
            }
            .store(in: cancelBag)
        
        input.attendanceButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onAttendanceButtonTapped?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickAttendanceNew)
            }
            .store(in: cancelBag)
        
        input.extendedFloatingButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onExtendedFloatingButtonTapped?(owner.floatingButtonUrl)
            }
            .store(in: cancelBag)
        
        input.surveyButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSurveyButtonTapped?(owner.surveyButtonURL)
            }
            .store(in: cancelBag)
        return output
    }
}

// MARK: - Methods

extension HomeForMemberViewModel {
    private func trackAmplitude(event: AmplitudeEventType?) {
        if let event {
            AmplitudeInstance.shared.trackWithUserType(event: event)
        }
    }
    
    private func requestAuthorizationForNotification() {
        guard self.userType != .visitor,
              UserDefaultKeyList.Auth.hasAccessToken(),
              UserDefaultKeyList.User.hasPushToken()
        else { return }
        
        // APNS 권한 허용 확인
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error { print(error) }
            AmplitudeInstance.shared.addPushNotificationAuthorizationIdentity(isAuthorized: granted)
            print("APNs-알림 권한 허용 유무 \(granted)")
            
            if granted {
                self.useCase.registerPushToken()
            }
        }
    }
}
