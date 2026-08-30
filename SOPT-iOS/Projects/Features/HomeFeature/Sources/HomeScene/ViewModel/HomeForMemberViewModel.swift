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
    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()
    
    let userType: UserType = UserDefaultKeyList.Auth.getUserType()
    
    private var fetchedDashBoard: HomePresentationModel.DashBoard?
    private var fetchedRecentSchedule: HomePresentationModel.RecentSchedule?
    private var fetchedSurvey: HomePresentationModel.Survey?
    private var fetchedFloatingButtonInfo: HomeFloatingButtonPresentationModel?
    @Published private(set) var isFABTapped: Bool = false

    let productServiceList: [HomePresentationModel.ProductService] = [
        .init(product: .member),
        .init(product: .group),
        .init(product: .project),
        .init(product: .coffeechat)
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
        let extendedFloatingButtonTapped: Driver<Void>
        let surveyButtonTapped: Driver<Void>
        let socialLinkButtonTapped: Driver<HomePresentationModel.SocialLink>
        let viewAllButtonTapped: Driver<HomeForMemberSectionLayoutKind>
        let profileImageViewTapped: Driver<PostInfo>
        let editProfileTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let isLoading = PassthroughSubject<Bool, Never>()
        let floatingButtonInfo = PassthroughSubject<HomeFloatingButtonPresentationModel, Never>()
    }
    
    // MARK: - HomeForMemberCoordinating
    
    public var onCalendarCellTapped: (() -> Void)?
    public var onAttendanceButtonTapped: (() -> Void)?
    public var onMainProductCellTapped: ((String) -> Void)?
    public var onAppServiceCellTapped: ((AppServiceType) -> Void)?
    public var onNotificationButtonTapped: (() -> Void)?
    public var onNeedSignIn: (@MainActor () -> Void)?
    public var onNetworkError: (@MainActor () -> Void)?
    public var onExtendedFloatingButtonTapped: ((String) -> Void)?
    public var onSurveyButtonTapped: ((String) -> Void)?
    public var onSocialLinkButtonTapped: ((String) -> Void)?
    public var onPopularPostCellTapped: ((String) -> Void)?
    public var onLatestPostCellTapped: ((String) -> Void)?
    public var onViewAllContentButtonTapped: ((String) -> Void)?
    public var onProfileImageViewTapped: ((Int) -> Void)?
    public var onFABMenuTapped: ((String) -> Void)?
    public var onEditProfileTapped: ((String) -> Void)?

    // MARK: - initialization
    
    public init(useCase: HomeUseCase, coordinator: Coordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
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
                AmplitudeInstance.shared.trackWithUserType(event: .viewAppHome)
            }.store(in: cancelBag)
        
        input.viewDidLoad
            .flatMap(useCase.getFloatingButtonInfo)
            .filter{ $0.isActive }
            .withUnretained(self)
            .sink { owner, floatingButtonModel in
                let presentationModel = floatingButtonModel.toPresentationModel()
                output.floatingButtonInfo.send(presentationModel)
                owner.fetchedFloatingButtonInfo = presentationModel
            }.store(in: cancelBag)
        
        input.cellTapped
            .withUnretained(self)
            .sink { owner, item in
                switch item {
                case .recentSchedule:
                    owner.onCalendarCellTapped?()
                    AmplitudeInstance.shared.trackWithUserType(event: .clickAllCalendar)
                case .productService(let model):
                    owner.onMainProductCellTapped?(model.product.serviceDomainLink)
                    owner.eventTracker.trackAmplitude(event: model.product.toAmplitudeEventType)
                case .socialLink(let type):
                    owner.onSocialLinkButtonTapped?(type.socialLink.serviceDomainLink)
                case .popularPost(let model):
                    owner.onPopularPostCellTapped?(model.webLink)
                    AmplitudeInstance.shared.trackWithUserType(event: .clickHotboard)
                case .latestPost(let model):
                    owner.onLatestPostCellTapped?(model.webLink)                    
                case .appService(let model):
                    owner.onAppServiceCellTapped?(model.type)
                    owner.eventTracker.trackAppService(serviceType: model.type)
                default: break
                }
            }
            .store(in: cancelBag)
        
        input.noticeButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNotificationButtonTapped?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickAlarm)
            }
            .store(in: cancelBag)
        
        input.attendanceButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onAttendanceButtonTapped?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickAttendacne)
            }
            .store(in: cancelBag)
        
        input.extendedFloatingButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                guard let info = owner.fetchedFloatingButtonInfo, !info.url.isEmpty else { return }
                owner.onExtendedFloatingButtonTapped?(info.url)
                owner.eventTracker.trackAmplitude(event: .clickToastButton)
            }
            .store(in: cancelBag)
        
        input.surveyButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                guard let survey = owner.fetchedSurvey, !survey.linkURL.isEmpty else { return }

                owner.onSurveyButtonTapped?(survey.linkURL)                
            }
            .store(in: cancelBag)
        
        input.viewAllButtonTapped
            .withUnretained(self)
            .sink { owner, sectionKind in
                switch sectionKind {
                case .mainProduct:
                    owner.onViewAllContentButtonTapped?(ExternalURL.Playground.main)
                default:
                    owner.onViewAllContentButtonTapped?(ExternalURL.Playground.feed)
                }

                let sectionName: HomeAmplitudeEventPropertyValue
                switch sectionKind {
                case .mainProduct:
                    sectionName = .mainProduct
                case .popularPosts:
                    sectionName = .popularPosts
                case .latestPosts:
                    sectionName = .latestPosts
                default:
                    sectionName = .latestPosts
                }                
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
        
        input.editProfileTapped
            .withUnretained(self)
            .sink { owner, url in
                owner.onEditProfileTapped?(ExternalURL.Playground.editProfile)
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
            switch mainError {
            case .networkError(_):
                await self.onNetworkError?()
            case .authFailed:
                await self.onNeedSignIn?()
            }
        } catch {
            await self.onNetworkError?()
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
            isAllConfirm: user?.isAllConfirm ?? false,
            profileImageURL: user?.profileImage ?? nil
        )
        UserDefaultKeyList.Auth.isActiveUser = user?.userType == .active // 사용자 활동 중 여부 등록
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
