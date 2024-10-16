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
    case clickHotboard = "click_hotboard"
    
    // 콕 찌르기 클릭 이벤트
    case clickPoke = "click_poke"
    case clickMemberProfile = "click_memberprofile"
    case clickPokeIcon = "click_poke_icon"
    case clickPokeAlarmDetail = "click_poke_alarm_detail"
    case clickPokeQuit = "click_poke_quit"
    
    // 솝마디 클릭 이벤트
    case clickCheckTodaySoptune = "click_check_todaysoptmadi"
    case clickLeaveSoptuneMain = "click_leave_soptmadi_title"
    case clickSoptuneRamdomPeople = "click_randomepeople"
    case clickGetSoptuneCard = "click_get_charmcard"
    case clickLeaveSoptuneResult = "click_leave_soptmadi_todays"
    case clickDoneHome = "click_done_home"
    case clickLeaveSoptuneCard = "click_done_soptmadi_charmcard"
    case clickAnonymity = "click_anonymity"
    case sendChoice = "send_choice"


    // 뷰 이벤트
    case viewAppHome = "view_apphome"
    case viewPokeOnboarding = "view_poke_onboarding"
    
    // 콕 찌르기 뷰 이벤트
    case viewPokeMain = "view_poke_main"
    case viewPokeAlarmDetail = "view_poke_alarm_detail"
    case viewPokeFriend = "view_poke_friend"
    case viewPokeFriendDetail = "view_poke_friend_detail"
    
    // 솝마디 뷰 이벤트
    case viewSoptuneMain = "view_soptmadi_title"
    case viewSoptuneResult = "view_soptmadi_todays"
    case viewSoptuenCard = "view_soptmadi_charmcard"
}
