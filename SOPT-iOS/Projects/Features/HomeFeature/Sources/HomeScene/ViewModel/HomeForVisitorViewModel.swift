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
    
    let productInfoList: [ProductInfo] = [
        ProductInfo(name: I18N.Home.MainProduct.homePage, image: DSKitAsset.Assets.imgHomepage.image),
        ProductInfo(name: I18N.Home.MainProduct.activityReview, image: DSKitAsset.Assets.imgGroupLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.project, image: DSKitAsset.Assets.imgMemberLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.instagram, image: DSKitAsset.Assets.imgInstagram.image)
    ]
    
    // TODO: 서버 연결 필요
    let appServiceInfoList: [AppServiceInfo] = [
        AppServiceInfo(name: "콕찌르기", imageURL: "https://images.mypetlife.co.kr/content/uploads/2018/12/09154907/cotton-tulear-2422612_1280.jpg", badgeText: ""),
        AppServiceInfo(name: "솝마디", imageURL: "https://images.mypetlife.co.kr/content/uploads/2018/12/09154907/cotton-tulear-2422612_1280.jpg", badgeText: ""),
        AppServiceInfo(name: "솝탬프", imageURL: "https://images.mypetlife.co.kr/content/uploads/2018/12/09154907/cotton-tulear-2422612_1280.jpg", badgeText: "")
    ]
    
    // MARK: - Properties

    private let useCase: HomeUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input { }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeForVisitorViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        return output
    }
}
