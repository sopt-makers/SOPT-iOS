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

public class HomeForMemberViewModel: HomeForMemberViewModelType {
    
    // MARK: - Properties
    
    let productInfoList: [ProductInfo] = [
        ProductInfo(name: I18N.Home.MainService.Services.playground, image: DSKitAsset.Assets.imgPlaygroundLogo.image),
        ProductInfo(name: I18N.Home.MainService.Services.groupAndStudy, image: DSKitAsset.Assets.imgGroupLogo.image),
        ProductInfo(name: I18N.Home.MainService.Services.member, image: DSKitAsset.Assets.imgMemberLogo.image),
        ProductInfo(name: I18N.Home.MainService.Services.project, image: DSKitAsset.Assets.imgProjectLogo.image)
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
