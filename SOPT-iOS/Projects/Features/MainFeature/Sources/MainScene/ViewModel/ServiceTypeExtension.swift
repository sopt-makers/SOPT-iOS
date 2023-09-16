//
//  ServiceTypeExtension.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

extension ServiceType {
    var icon: UIImage {
        switch self {
        case .officialHomepage:
            return DSKitAsset.Assets.icnHomepage.image
        case .review:
            return DSKitAsset.Assets.icnReview.image
        case .project:
            return DSKitAsset.Assets.icnProject.image
        case .faq:
            return DSKitAsset.Assets.icnFaq.image
        case .youtube:
            return DSKitAsset.Assets.icnYoutube.image
        case .attendance:
            return DSKitAsset.Assets.icnAttendance.image
        case .member:
            return DSKitAsset.Assets.icMember.image
        case .group:
            return DSKitAsset.Assets.icCrew.image
        case .instagram:
            return DSKitAsset.Assets.icnInstagram.image
        }
    }
    
    var title: String {
        switch self {
        case .officialHomepage:
            return I18N.Main.MainService.Title.officialHomePage
        case .review:
            return I18N.Main.MainService.Title.review
        case .project:
            return I18N.Main.MainService.Title.project
        case .faq:
            return I18N.Main.MainService.Title.faq
        case .youtube:
            return I18N.Main.MainService.Title.youtube
        case .attendance:
            return I18N.Main.MainService.Title.attendance
        case .member:
            return I18N.Main.MainService.Title.member
        case .group:
            return I18N.Main.MainService.Title.group
        case .instagram:
            return I18N.Main.MainService.Title.instagram
        }
    }
    
    var description: String {
        switch self {
        case .officialHomepage:
            return I18N.Main.MainService.Description.officialHomePage
        case .review:
            return I18N.Main.MainService.Description.review
        case .project:
            return I18N.Main.MainService.Description.project
        case .faq:
            return I18N.Main.MainService.Description.faq
        case .youtube:
            return I18N.Main.MainService.Description.youtube
        case .attendance:
            return I18N.Main.MainService.Description.attendance
        case .member:
            return I18N.Main.MainService.Description.member
        case .group:
            return I18N.Main.MainService.Description.group
        case .instagram:
            return I18N.Main.MainService.Description.instagram
        }
    }
    
    
    var mainTitle: String? {
        switch self {
        case .officialHomepage:
            return I18N.Main.MainService.MainTitle.officialHomePage
        case .attendance:
            return I18N.Main.MainService.MainTitle.attendance
        case .group:
            return I18N.Main.MainService.MainTitle.group
        default:
            return nil
        }
    }
}
    
extension AppServiceType {
    var image: UIImage {
        switch self {
        case .soptamp:
            return DSKitAsset.Assets.soptampLogo.image
        }
    }
    
    var title: String {
        switch self {
        case .soptamp:
            return I18N.Main.AppService.soptamp
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .soptamp:
            return DSKitAsset.Colors.white.color
        }
    }
}

