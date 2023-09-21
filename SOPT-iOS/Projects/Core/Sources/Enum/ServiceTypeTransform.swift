//
//  ServiceTypeTransform.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public extension ServiceType {
    var toAmplitudeEventType: AmplitudeEventType {
        switch self {
            case .officialHomepage: return .officialHomepage
            case .review: return .review
            case .project: return .project
            case .faq: return .faq
            case .youtube: return .youtube
            case .attendance: return .attendacne
            case .member: return .member
            case .group: return .group
            case .instagram: return .instagram
        }
    }
}

public extension AppServiceType {
    var toAmplitudeEventType: AmplitudeEventType {
        switch self {
        case .soptamp: return .soptamp
        }
    }
}
