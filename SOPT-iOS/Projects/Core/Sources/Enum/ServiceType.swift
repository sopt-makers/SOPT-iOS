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
    case project
    case faq
    case youtube
    case attendance
    case member
    case group
    case instagram
    case coffeechat

    public var serviceDomainLink: String {
        switch self {
        case .officialHomepage: return ExternalURL.SOPT.officialHomepage
        case .project: return ExternalURL.Playground.project
        case .faq: return ExternalURL.SOPT.faq
        case .youtube: return ExternalURL.SNS.youtube
        case .attendance: return ""
        case .member: return ExternalURL.Playground.member
        case .group: return ExternalURL.Playground.group
        case .instagram: return ExternalURL.SNS.instagram
        case .coffeechat: return ExternalURL.Playground.coffeechat
        }
    }
}

public enum TabServiceType: String {
    case poke = "POKE"
}

public enum AppServiceType: String {
    case soptletter = "SOPTLETTER"
}
