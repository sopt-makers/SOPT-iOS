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
    
    let userType: UserType = UserDefaultKeyList.Auth.getUserType()
    
    let productServiceList: [HomePresentationModel.ProductService] = [
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.homePage, image: DSKitAsset.Assets.imgHomepage.image),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.activityReview, image: DSKitAsset.Assets.imgGroupLogo.image),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.project, image: DSKitAsset.Assets.imgMemberLogo.image),
        HomePresentationModel.ProductService(name: I18N.Home.MainProduct.instagram, image: DSKitAsset.Assets.imgInstagram.image)
    ]
    
    // MARK: - Properties

    private let useCase: HomeUseCase
    private var cancelBag = CancelBag()
        
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let appService = PassthroughSubject<[HomePresentationModel.AppService], Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeForVisitorViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .flatMap(useCase.getAppServices)
            .withUnretained(self)
            .sink { owner, appServiceModel in
                let appService = appServiceModel.map { $0.toPresentation() }
                output.appService.send(appService)
            }.store(in: cancelBag)
        
        return output
    }
}
