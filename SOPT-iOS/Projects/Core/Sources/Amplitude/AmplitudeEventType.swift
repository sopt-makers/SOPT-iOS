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
    case clickToastButton = "click_toast_button"
    case clickGroup = "click_group"
    case clickProject = "click_project"
    case clickMember = "click_member"
    case clickOfficialHomepage = "click_homepage"
    case clickSoptamp = "click_soptamp"
    case clickInstagram = "click_instagram"
    case clickYoutube = "click_youtube"    
    case clickFaq = "click_faq"
    case clickPlusButton = "click_plus_button"
    case clickPlaygroundCommunity = "click_playground_community"
    case clickHotboard = "click_hotboard"
    case clickShortcutButton = "click_link.btn"
    case clickReadAllButton = "click_allread.btn"
    case clickNotificationItem = "click_notification_item"
    case clickCoffeeChat = "click_playground_coffee_chat"        // 먼저 배포된 안드로이드 컨벤션에 맞춤. 앰플리튜드 tf 개설 후 click_으로 통일하여 사용할 예정
    
    // 신규 홈 클릭 이벤트
    case clickAllCalendar = "click_all_calendar"
    case clickPlaygroudGroup = "click_playground_group"
    case clickPokeMenu = "click_poke_menu"
    case clickTodaySoptmadi = "click_todaysoptmadi"
    case clickSoptampMenu = "click_soptamp_menu"
    case clickPostMember = "click_post_member"
    case clickPost = "click_post"
    case clickEmpty = "click_empty"
    case clickViewAll = "click_view_all"
    case clickPromo = "click_promo"
    case clickSoptletterMenu = "click_soptletter_menu"
    
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
    case clickNaviMyPage = "click_navi_mypage"
    case clickNaviSoptamp = "click_navi_soptamp"
    case clickNaviPoke = "click_navi_poke"

    // 홈 뷰 이벤트
    case viewAppHome = "view_apphome"
    case viewNotificationDetail = "view_notification_detail"
    case viewNotificationList = "view_notification_list"
    
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
    
    // 박수 이벤트
    case clickUpdateClap = "click_update_clap"
    case getImageZoom = "get_image_zoom"
    case clickClappersList = "click_clappersList"
    case clickFeedMission = "click_feed_mission"
}
