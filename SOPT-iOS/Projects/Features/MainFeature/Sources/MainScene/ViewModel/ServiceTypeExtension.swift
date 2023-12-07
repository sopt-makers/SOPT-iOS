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
        case .playgroundCommunity:
            return DSKitAsset.Assets.icMember.image
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
        case .playgroundCommunity:
            return I18N.Main.MainService.Title.playgroundCommunity
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
        case .playgroundCommunity:
            return I18N.Main.MainService.MainTitle.playgroundCommunity
        default:
            return nil
        }
    }
    
    func description(for userType: UserType) -> String? {
        switch self {
        case .officialHomepage:
            return userType == .active ? I18N.Main.MainService.Description.Default.officialHomePage : nil
        case .review:
            return I18N.Main.MainService.Description.Default.review
        case .project:
            switch userType {
            case .active:
                return I18N.Main.MainService.Description.ActiveUser.project
            case .inactive:
                return I18N.Main.MainService.Description.InactiveUser.project
            case .visitor:
                return I18N.Main.MainService.Description.Visitor.project
            }
        case .faq:
            return I18N.Main.MainService.Description.Default.faq
        case .youtube:
            return userType == .inactive ? nil : I18N.Main.MainService.Description.Default.youtube
        case .attendance:
            return I18N.Main.MainService.Description.Default.attendance
        case .member:
            return I18N.Main.MainService.Description.Default.member
        case .group:
            return I18N.Main.MainService.Description.Default.group
        case .instagram:
            return userType == .inactive ? nil : I18N.Main.MainService.Description.Default.instagram
        case .playgroundCommunity:
            return userType == .active ?
            I18N.Main.MainService.Description.ActiveUser.playgroundCommunity : I18N.Main.MainService.Description.InactiveUser.playgroundCommunity
        }
    }
}
    
extension AppServiceType {
    var image: UIImage {
        switch self {
        case .soptamp:
            return DSKitAsset.Assets.imgSoptamp.image
        case .poke:
            return DSKitAsset.Assets.iconKok.image
        }
    }
    
    var title: String {
        switch self {
        case .soptamp:
            return I18N.Main.AppService.soptamp
        case .poke:
            return "콕 찌르기(임시)"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .soptamp:
            return DSKitAsset.Colors.gray800.color
        case .poke:
            return DSKitAsset.Colors.gray800.color
        }
    }
}

