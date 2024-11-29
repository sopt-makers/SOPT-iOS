//
//  HomeForMemberViewModel.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import UIKit
import Combine

import Core
import Domain
import DSKit

import HomeFeatureInterface
import BaseFeatureDependency

struct ProductInfo {
    let name: String
    let image: UIImage
}

struct AppServiceInfo {
    let name: String
    let imageURL: String
    let badgeText: String
}

struct InsightInfo {
    let category: String
    let profileImageURL: UIImage
    let userName: String
    let postTitle: String
    let isHotTag: Bool
}

public class HomeForMemberViewModel: HomeForMemberViewModelType {
    
    // MARK: - Properties
    
    let productInfoList: [ProductInfo] = [
        ProductInfo(name: I18N.Home.MainProduct.playground, image: DSKitAsset.Assets.imgPlaygroundLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.groupAndStudy, image: DSKitAsset.Assets.imgGroupLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.member, image: DSKitAsset.Assets.imgMemberLogo.image),
        ProductInfo(name: I18N.Home.MainProduct.project, image: DSKitAsset.Assets.imgProjectLogo.image)
    ]
    
    // TODO: 서버 연결 필요
    let appServiceInfoList: [AppServiceInfo] = [
        AppServiceInfo(name: "콕찌르기", imageURL: "", badgeText: "3"),
        AppServiceInfo(name: "솝마디", imageURL: "", badgeText: "N"),
        AppServiceInfo(name: "솝탬프", imageURL: "", badgeText: "3위")
    ]
    
    // TODO: 서버 연결 필요
    let insightInfoList: [InsightInfo] = [
        InsightInfo(category: "SOPT활동", profileImageURL: DSKitAsset.Assets.imgMemberLogo.image, userName: "차은우", postTitle: "차은우가 솝트 기획으로 활동한 썰 푼다 최대글자수입니다람지렁이", isHotTag: false)
    ]
    
    // MARK: - Inputs
    
    public struct Input { }
    
    // MARK: - Outputs
    
    public struct Output { }
    
    // MARK: - initialization
    
    public init() { }
}

extension HomeForMemberViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        return output
    }
}
