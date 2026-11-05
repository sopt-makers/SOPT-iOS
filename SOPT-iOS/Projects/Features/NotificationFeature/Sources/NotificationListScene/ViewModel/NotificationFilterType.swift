//
//  NotificationFilterType.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

enum NotificationFilterType: String {
    case all = "전체 알림"
    case officialNotice = "전체 공지"
    case generalNotice = "일반 알림"
    case news = "소식"
    
    var serverKey: String {
        switch self {
        case .all: return "ALL"
        case .officialNotice: return "OFFICIAL" // TODO: 서버 나오면 수정
        case .generalNotice: return "NOTICE"
        case .news: return "NEWS"
        }
    }
}
