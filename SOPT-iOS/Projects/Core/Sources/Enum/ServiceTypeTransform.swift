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
        case .project: return .clickPlaygroundProject
        case .youtube: return .clickYoutube
        case .attendance: return .clickAttendacne
        case .member: return .clickPlaygroundMember
        case .group: return .clickPlaygroundGroup
        case .instagram: return .clickInstagram
        case .coffeechat: return .clickCoffeeChat
        }
    }
}
