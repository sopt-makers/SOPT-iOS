//
//  AmplitudeEventType.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum AmplitudeEventType: String {
    // 서비스 클릭 이벤트
    case main = "view_apphome"
    case alarm = "click_alarm"
    case myPage = "click_mypage"
    case attendacne = "click_attendance"
    case group = "click_group"
    case project = "click_project"
    case member = "click_member"
    case officialHomepage = "click_homepage"
    case soptamp = "click_soptamp"
    case instagram = "click_instagram"
    case youtube = "click_youtube"
    case review = "click_review"
    case faq = "click_faq"
    case playgroundCommunity = "click_playground_community"
    case poke = "click_poke"
}
