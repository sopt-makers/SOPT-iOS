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
        case .notice:
            return DSKitAsset.Assets.icnNotice.image
        case .crew:
            return DSKitAsset.Assets.icCrew.image
        }
    }
    
    var title: String {
        switch self {
        case .officialHomepage:
            return I18N.Main.MainService.officialHomePage
        case .review:
            return I18N.Main.MainService.review
        case .project:
            return I18N.Main.MainService.project
        case .faq:
            return I18N.Main.MainService.faq
        case .youtube:
            return I18N.Main.MainService.youtube
        case .attendance:
            return I18N.Main.MainService.attendance
        case .member:
            return I18N.Main.MainService.member
        case .notice:
            return I18N.Main.MainService.notice
        case .crew:
            return I18N.Main.MainService.crew
        }
    }
    
    var description: String? {
        switch self {
        case .attendance:
            return I18N.Main.MainService.attend
        case .notice:
            return I18N.Main.MainService.checkGeneralNotice
        case .faq:
            return I18N.Main.MainService.inquire
        default:
            return nil
        }
    }
    
    var alternativeTitle: String? {
        switch self {
        case .officialHomepage:
            return I18N.Main.MainService.AlternativeService.officialHomePage
        case .notice:
            return I18N.Main.MainService.AlternativeService.notice
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
