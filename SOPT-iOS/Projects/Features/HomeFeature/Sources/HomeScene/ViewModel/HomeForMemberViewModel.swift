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
    
    private var fetchedDashBoard: HomePresentationModel.DashBoard?
    private var fetchedRecentSchedule: HomePresentationModel.RecentSchedule?
    private var fetchedSurvey: HomePresentationModel.Survey?
    private var fetchedFABInfo: HomeFloatingButtonPresentationModel?
            
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
    
    private let eventTracker = HomeEventTracker()
    
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
        let viewAllButtonTapped: Driver<Void>
        let profileImageViewTapped: Driver<PostInfo>
    }
    
    // MARK: - Outputs
    
    public struct Output {
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
    public var onPopularPostCellTapped: ((String) -> Void)?
    public var onLatestPostCellTapped: ((String) -> Void)?
    public var onViewAllContentButtonTapped: ((String) -> Void)?
    public var onProfileImageViewTapped: ((Int) -> Void)?
    
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
                owner.fetchedFABInfo = presentationModel
            }.store(in: cancelBag)
        
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
                    owner.eventTracker.trackAmplitude(event: model.product.toAmplitudeEventTypeNew)
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
                case .popularPost(let model):
                    owner.onPopularPostCellTapped?(model.webLink)
                    owner.eventTracker.trackClickPost(
                        postRanking: model.rank,
                        sectionName: .realTimeFeed,
                        postID: model.serverID,
                        category: model.category
                    )
                case .latestPost(let model):
                    owner.onLatestPostCellTapped?(model.webLink)
                    owner.trackLatestPostEvent(model: model)
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
                guard let info = owner.fetchedFABInfo, !info.url.isEmpty else { return }
                owner.onExtendedFloatingButtonTapped?(info.url)
                owner.eventTracker.trackClickPromo(
                    sectionName: .homeFAB,
                    promoName: info.actionButtonName,
                    destinationURL: info.url,
                    destinationType: .app
                )
            }
            .store(in: cancelBag)
        
        input.surveyButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                guard let survey = owner.fetchedSurvey, !survey.linkURL.isEmpty else { return }

                owner.onSurveyButtonTapped?(survey.linkURL)
                owner.eventTracker.trackClickPromo(
                    sectionName: .homeBanner,
                    promoName: survey.title,
                    destinationURL: survey.linkURL,
                    destinationType: .web
                )
            }
            .store(in: cancelBag)
        
        input.viewAllButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onViewAllContentButtonTapped?(ExternalURL.Playground.main)
                owner.eventTracker.trackClickViewAll(sectionName: .latestPosts)
            }
            .store(in: cancelBag)
        
        input.profileImageViewTapped
            .withUnretained(self)
            .sink { owner, model in
                if let userID = model.userID {
                    owner.onProfileImageViewTapped?(userID)
                    owner.eventTracker.trackClickPostMember(
                        postRanking: model.postRanking,
                        sectionName: model.sectionName,
                        postID: model.postID,
                        category: model.category
                    )
                }
                
            }
            .store(in: cancelBag)
        
        return output
    }
}

// MARK: - Methods

extension HomeForMemberViewModel {
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
    
    private func trackLatestPostEvent(model: HomePresentationModel.LatestPost) {
        // 이름 필드의 유무에 따라, 엠티 뷰의 유무를 결정하며 이벤트도 분리해 처리합니다.
        if let name = model.name, !name.isEmpty {
            eventTracker.trackClickPost(
                sectionName: .latestPosts,
                postID: model.serverID,
                category: model.category
            )
        } else {
            eventTracker.trackClickEmpty(
                sectionName: .latestPosts,
                category: model.category
            )
        }
    }
}

// MARK: - Fetch Home Data

extension HomeForMemberViewModel {
    func fetchHomeData() async -> HomePresentationModel? {
        let model: HomePresentationModel?
        
        do {
            async let dashBoard = fetchDashBoard()
            async let recentSchedule = fetchRecentSchedule()
            async let survey = fetchSurvey()
            async let appService = useCase.getAppServicesAsync()
            async let popularPosts = useCase.getPopularPostsAsync()
            async let latestPosts = useCase.getLatestPostsAsync()
                        
            model = HomePresentationModel(
                dashBoard: try await dashBoard,
                recentSchedule: try await recentSchedule,
                appServices: (try? await appService.map { $0.toPresentation() }) ?? [],
                popularPosts: (try? await popularPosts.map { $0.toPresentation() }) ?? [],
                latestPosts: (try? await latestPosts.map { $0.toPresentation() }) ?? [],
                survey: try await survey
            )
            
            return model
        } catch let mainError as MainError {
            await MainActor.run {
                switch mainError {
                case .networkError(_):
                    self.onNetworkError?()
                case .authFailed:
                    self.onNeedSignIn?()
                }
            }
        } catch {
            await MainActor.run {
                self.onNetworkError?()
            }
        }
        
        return nil
    }
    
    // 각 함수들은 이미 fetch된 데이터가 있다면 통신 요청 없이 해당 데이터를 사용합니다.
    private func fetchDashBoard() async throws -> HomePresentationModel.DashBoard {
        if let cached = fetchedDashBoard { return cached }
        let description = try await useCase.getHomeDescriptionAsync()
        let user = try await useCase.getUserInfoAsync()
        let dashBoard = description.toPresentation(
            history: user?.historyList ?? [],
            isAllConfirm: user?.isAllConfirm ?? false
        )
        fetchedDashBoard = dashBoard
        return dashBoard
    }
    
    private func fetchRecentSchedule() async throws -> HomePresentationModel.RecentSchedule {
        if let cached = fetchedRecentSchedule { return cached }
        let entity = try await useCase.getRecentScheduleAsync()
        let recentSchedule = entity.toPresentation()
        fetchedRecentSchedule = recentSchedule
        return recentSchedule
    }
    
    private func fetchSurvey() async throws -> HomePresentationModel.Survey {
        if let cached = fetchedSurvey { return cached }
        let entity = try await useCase.getSurveyInfoAsync()
        let survey = entity.toPresentation()
        fetchedSurvey = survey
        return survey
    }
}
