//
//  ServiceTypeExtension.swift
//  HomeFeature
//
//  Created by 강윤서 on 3/25/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

extension ServiceType {
    var icon: UIImage {
        switch self {
        case .officialHomepage:
            return DSKitAsset.Assets.imgHomepage.image
        case .review:
            return DSKitAsset.Assets.imgReviewLogo.image
        case .project:
            let userType = UserDefaultKeyList.Auth.getUserType()
            return userType == .visitor ? DSKitAsset.Assets.imgProjectLogo.image : DSKitAsset.Assets.imgActiveProjectLogo.image
        case .member:
            return DSKitAsset.Assets.imgUserLogo.image
        case .group:
            return DSKitAsset.Assets.imgGroupLogo.image
        case .instagram:
            return DSKitAsset.Assets.imgInstagram.image
        case .coffeechat:
            return DSKitAsset.Assets.icCoffeechat.image
        case .youtube:
            return DSKitAsset.Assets.icYoutube.image
        default:
            return UIImage()
        }
    }
    
    var title: String {
        switch self {
        case .officialHomepage:
            return I18N.Home.MainProduct.homePage
        case .review:
            return I18N.Home.MainProduct.activityReview
        case .project:
            return I18N.Home.MainProduct.project
        case .member:
            return I18N.Home.MainProduct.member
        case .group:
            return I18N.Home.MainProduct.groupAndStudy
        case .instagram:
            return I18N.Home.MainProduct.instagram
        case .coffeechat:
            return I18N.Home.MainProduct.coffeechat
        case .youtube:
            return I18N.Home.SocialLink.youtube
        default:
            return ""
        }
    }
}
