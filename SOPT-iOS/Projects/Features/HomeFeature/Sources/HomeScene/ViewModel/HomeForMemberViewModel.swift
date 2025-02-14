//
//  HomeForMemberViewModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.


import Foundation
import UIKit
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
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.playground, image: DSKitAsset.Assets.imgPlaygroundLogo.image),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.groupAndStudy, image: DSKitAsset.Assets.imgGroupLogo.image),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.member, image: DSKitAsset.Assets.imgMemberLogo.image),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.project, image: DSKitAsset.Assets.imgProjectLogo.image)
    ]
    
    // MARK: - Inputs
    
    public struct Input {
        let cellTapped: Driver<IndexPath>
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let homeItem = PassthroughSubject<HomePresentationModel, Never>()
    }
    
    // MARK: - HomeForMemberCoordinating
    
    public var onDashBoardCellTapped: (() -> Void)?
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeForMemberViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .flatMap { _ in
                Publishers.Zip3(
                    self.useCase.getHomeDescription().map { $0.toPresentation() },
                    self.useCase.getRecentSchedule().map { $0.toPresentation() },
                    self.useCase.getAppServices().map { $0.map { $0.toPresentation() } }
                )
                .map { description, recentSchedule, appService in
                    HomePresentationModel(
                        description: description,
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
            }
            .store(in: cancelBag)
        
        input.cellTapped
            .filter{ $0.section == 1 }
            .withUnretained(self)
            .sink(receiveValue: { owner, indexPath in
                owner.onDashBoardCellTapped?()
            })
            .store(in: cancelBag)
        
        return output
    }
}
