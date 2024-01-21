//
//  AmplitudeEventType.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum AmplitudeEventType: String {
    // 클릭 이벤트
    case clickAlarm = "click_alarm"
    case clickMyPage = "click_mypage"
    case clickAttendacne = "click_attendance"
    case clickGroup = "click_group"
    case clickProject = "click_project"
    case clickMember = "click_member"
    case clickOfficialHomepage = "click_homepage"
    case clickSoptamp = "click_soptamp"
    case clickInstagram = "click_instagram"
    case clickYoutube = "click_youtube"
    case clickReview = "click_review"
    case clickFaq = "click_faq"
    case clickPlaygroundCommunity = "click_playground_community"
    case clickPoke = "click_poke"
    case clickMemberProfile = "click_memberProfile"
    case clickPokeIcon = "click_poke_icon"
    case clickPokeAlarmDetail = "click_poke_alarm_detail"
    case clickPokeQuit = "click_poke_quit"
    
    // 뷰 이벤트
    case viewAppHome = "view_apphome"
    case viewPokeOnboarding = "view_poke_onboarding"
    case viewPokeMain = "view_poke_main"
}
