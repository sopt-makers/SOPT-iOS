//
//  HomeForMemberViewModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.


import Foundation
import Combine

import Core
import Domain
import DSKit

import HomeFeatureInterface
import BaseFeatureDependency

public class HomeForMemberViewModel: HomeForMemberViewModelType {
    
    // MARK: - Properties

    private let useCase: HomeUseCase
    private var cancelBag = CancelBag()
    
    let currentCardPage = PassthroughSubject<Int, Never>()
    let userType: UserType = UserDefaultKeyList.Auth.getUserType()
    
    let productServiceList: [HomePresentationModel.ProductService] = [
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.playground, image: DSKitAsset.Assets.imgPlaygroundLogo.image, url: ExternalURL.Playground.main),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.groupAndStudy, image: DSKitAsset.Assets.imgGroupLogo.image, url: ExternalURL.Playground.group),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.member, image: DSKitAsset.Assets.imgMemberLogo.image, url: ExternalURL.Playground.member),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.project, image: DSKitAsset.Assets.imgProjectLogo.image, url: ExternalURL.Playground.project)
    ]
    
    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let cellTapped: Driver<HomeForMemberItem>
        let attendanceButtonTapped: Driver<Void>
        let noticeButtonTapped: Driver<Void>
        let settingButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let homeItem = PassthroughSubject<HomePresentationModel, Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - HomeForMemberCoordinating
    
    public var onDashBoardCellTapped: (() -> Void)?
    public var onCalendarCellTapped: (() -> Void)?
    public var onAttendanceButtonTapped: (() -> Void)?
    public var onMainProductCellTapped: ((String) -> Void)?
    public var onAppServiceCellTapped: ((String) -> Void)?
    public var onNotificationButtonTapped: (() -> Void)?
    public var onSettingButtonTapped: ((UserType) -> Void)?
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeForMemberViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.viewWillAppear
            .handleEvents(receiveOutput: { _ in
                output.isLoading.send(true)
            })
            .flatMap { _ in
                self.useCase.getUserInfo()
            }
            .compactMap { $0 }
            .flatMap { userInfo in
                Publishers.Zip3(
                    self.useCase.getHomeDescription().map { $0.toPresentation(history: userInfo.historyList, isAllConfirm: userInfo.isAllConfirm) },
                    self.useCase.getRecentSchedule().map { $0.toPresentation() },
                    self.useCase.getAppServices().map { $0.map { $0.toPresentation() } }
                )
                .map { dashBoard, recentSchedule, appService in
                    HomePresentationModel(
                        dashBoard: dashBoard,
                        recentSchedule: recentSchedule,
                        appServices: appService
                    )
                }
            }
            // TODO: 이후 스프린트에서 순차 배포
//            .flatMap {
//                description,
//                recentSchedule,
//                appService in
//                Publishers.Zip4(
//                    self.useCase.getInsightPosts().map { $0.map { $0.toPresentation() } },
//                    self.useCase.getGroupPosts().map { $0.map { $0.toPresentation() } },
//                    self.useCase.getCoffeeChatPosts().map { $0.map { $0.toPresentation() } },
//                    self.useCase.getAnnouncementPosts().map { $0.map { $0.toPresentation() } }
//                )
//                .map { insight, group, coffeeChat, announcement in
//                    HomePresentationModel(
//                        description: description,
//                        recentSchedule: recentSchedule,
//                        appServices: appService,
//                        insightPosts: insight,
//                        groupPosts: group,
//                        coffeeChatPosts: coffeeChat,
//                        announcementPosts: announcement
//                    )
//                }
//            }
            .withUnretained(self)
            .sink { owner, data in
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
                case .productService(let model):
                    owner.onMainProductCellTapped?(model.url)
                case .appService(let model):
                    owner.onAppServiceCellTapped?(model.deepLink)
                default: break
                }
            }
            .store(in: cancelBag)
        
        input.noticeButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNotificationButtonTapped?()
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
            }
            .store(in: cancelBag)
        
        return output
    }
}
