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
}
