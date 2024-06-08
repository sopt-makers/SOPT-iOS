//
//  ServiceType.swift
//  Core
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum ServiceType {
    case officialHomepage
    case review
    case project
    case faq
    case youtube
    case attendance
    case member
    case group
    case instagram
    case playgroundCommunity
    
    public var serviceDomainLink: String {
        switch self {
        case .officialHomepage: return ExternalURL.SOPT.officialHomepage
        case .review: return ExternalURL.SOPT.review
        case .project: return ExternalURL.Playground.project
        case .faq: return ExternalURL.SOPT.faq
        case .youtube: return ExternalURL.SNS.youtube
        case .attendance: return ""
        case .member: return ExternalURL.Playground.member
        case .group: return ExternalURL.Playground.group
        case .instagram: return ExternalURL.SNS.instagram
        case .playgroundCommunity: return ExternalURL.Playground.playgroundCommunity
        }
    }
}

public enum AppServiceType: String {
    case soptamp = "SOPTAMP"
    case poke = "POKE"
}
