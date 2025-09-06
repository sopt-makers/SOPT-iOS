//
//  AmplitudeEventType.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum AmplitudeEventType: String {
    // 푸시 알림 이벤트
    case receivedPush = "received_push"
    case clickPush = "click_push"
    
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
    case clickShortcutButton = "click_link.btn"
    case clickReadAllButton = "click_allread.btn"
    case clickNotificationItem = "click_notification_item"
    
    // 신규 홈 클릭 이벤트
    case clickAttendanceNew = "at36_click_attendance"
    case clickAlarmNew = "at36_click_alarm"
    case clickAllCalendar = "click_all_calendar"
    case clickPlaygroundCommunityNew = "at36_click_playground_community"
    case clickMoim = "click_moim"
    case clickMemberNew = "at36_click_member"
    case clickProjectNew = "at36_click_project"
    case clickPokeMenu = "click_poke_menu"
    case clickTodaySoptuneMenu = "click_todaysoptmadi_menu"
    case clickSoptampMenu = "click_soptamp_menu"
    case clickPostMember = "click_post_member"
    case clickPost = "click_post"
    case clickEmpty = "click_empty"
    case clickViewAll = "click_view_all"
    case clickPromo = "click_promo"
    
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
    
    // 탭 바 클릭 이벤트
    case clickNaviHome = "click_navi_home"
    case clickNaviSoptlog = "click_navi_soptlog"

    // 기존 홈 뷰 이벤트
    case viewAppHome = "view_apphome"
    case viewNotificationDetail = "view_notification_detail"
    case viewNotificationList = "view_notification_list"

    // 신규 홈 뷰 이벤트
    case viewAppHomeNew = "at36_view_apphome"
    
    // 콕 찌르기 뷰 이벤트
    case viewPokeOnboarding = "view_poke_onboarding"
    case viewPokeMain = "view_poke_main"
    case viewPokeAlarmDetail = "view_poke_alarm_detail"
    case viewPokeFriend = "view_poke_friend"
    case viewPokeFriendDetail = "view_poke_friend_detail"
    
    // 솝마디 뷰 이벤트
    case viewSoptuneMain = "view_soptmadi_title"
    case viewSoptuneResult = "view_soptmadi_todays"
    case viewSoptuenCard = "view_soptmadi_charmcard"
    
    // 솝트로그 뷰 이벤트
    case clickSoptlogEditProfile = "click_soptlog_editprofile"
    case clickSoptlogSoptune = "click_soptlog_soptmadi"
}
