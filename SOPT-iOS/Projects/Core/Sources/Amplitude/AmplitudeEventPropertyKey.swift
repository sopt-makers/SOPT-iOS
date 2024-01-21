//
//  AmplitudeEventPropertyKey.swift
//  Core
//
//  Created by sejin on 1/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum AmplitudeEventPropertyKey: String {
    case viewType = "view_type"
    case clickViewType = "click_view_type"
    
    // 콕 찌르기 피쳐 관련 Key
    case viewProfile = "view_profile" // 멤버 프로필 id
    case friendType = "friend_type"
}
