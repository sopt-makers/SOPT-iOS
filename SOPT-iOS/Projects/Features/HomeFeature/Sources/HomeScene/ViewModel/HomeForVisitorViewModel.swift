//
//  HomeForVisitorViewModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import DSKit

import HomeFeatureInterface
import BaseFeatureDependency

public class HomeForVisitorViewModel: HomeForVisitorViewModelType {
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private var cancelBag = CancelBag()
    let userType: UserType = .visitor
    
    let productServiceList: [HomePresentationModel.ProductService] = [
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.homePage, image: DSKitAsset.Assets.imgHomepage.image, url: ExternalURL.SOPT.officialHomepage),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.activityReview, image: DSKitAsset.Assets.imgGroupLogo.image, url: ExternalURL.SOPT.review),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.project, image: DSKitAsset.Assets.imgMemberLogo.image, url: ExternalURL.SOPT.project),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.instagram, image: DSKitAsset.Assets.imgInstagram.image, url: ExternalURL.SNS.instagram)
    ]

        
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let cellTapped: Driver<HomeForVisitorItem>
        let settingButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let appService = PassthroughSubject<[HomePresentationModel.AppService], Never>()
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - HomeForVisitorCoordinating
    
    public var onMainProductCellTapped: ((String) -> Void)?
    public var onAppServiceCellTapped: (() -> Void)?
    public var onSettingButtonTapped: ((UserType) -> Void)?
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeForVisitorViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .handleEvents(receiveOutput: {
                output.isLoading.send(true)
            })
            .flatMap(useCase.getAppServices)
            .withUnretained(self)
            .sink { owner, appServiceModel in
                let appService = appServiceModel.map { $0.toPresentation() }
                output.appService.send(appService)
                output.isLoading.send(false)
            }.store(in: cancelBag)
        
        input.cellTapped
            .withUnretained(self)
            .sink { owner, item in
                switch item {
                case .appService:
                    owner.onAppServiceCellTapped?()
                case .productService(let model):
                    owner.onMainProductCellTapped?(model.url)
                default: break
                }
            }
            .store(in: cancelBag)
        
        input.settingButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSettingButtonTapped?(owner.userType)
            }
            .store(in: cancelBag)
        
        return output
    }
}
