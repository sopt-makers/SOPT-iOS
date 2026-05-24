//
//  ServiceTypeTransform.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public extension ServiceType {
    var toAmplitudeEventType: AmplitudeEventType? {
        switch self {
        case .officialHomepage: return .clickOfficialHomepage
        case .review: return .clickReview
        case .project: return .clickProject
        case .faq: return .clickFaq
        case .youtube: return .clickYoutube
        case .attendance: return .clickAttendacne
        case .member: return .clickMember
        case .group: return .clickMoim
        case .instagram: return .clickInstagram
        case .coffeechat: return nil
        }
    }
}

public extension AppServiceType {
    var toAmplitudeEventType: AmplitudeEventType {
        switch self {
        case .soptamp: return .clickSoptamp
        case .poke: return .clickPoke
        }
    }
}
