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
    case clickAttendacne = "click_attendance"
    case clickToastButton = "click_toast_button"
    case clickProject = "click_project"
    case clickMember = "click_member"
    case clickOfficialHomepage = "click_homepage"    
    case clickInstagram = "click_instagram"
    case clickYoutube = "click_youtube"    
    case clickFaq = "click_faq"
    case clickPlusButton = "click_plus_button"
    case clickHotboard = "click_hotboard"
    case clickLink = "click_link_button"
    case clickReadAll = "click_allread_button"
    case clickNotificationItem = "click_notification_item"
    case clickCoffeeChat = "click_playground_coffee_chat"
    case clickSurveyButton = "click_survey_button"
    
    // 신규 홈 클릭 이벤트
    case clickAllCalendar = "click_all_calendar"
    case clickPlaygroudGroup = "click_playground_group"
    case clickSoptampMenu = "click_soptamp_menu"
    case clickPostMember = "click_post_member"    
    case clickEmpty = "click_empty"
    case clickSoptletterMenu = "click_soptletter_menu"
    
    // 콕 찌르기 클릭 이벤트
    case clickPoke = "click_poke"
    case clickMemberProfile = "click_memberprofile"
    case clickPokeIcon = "click_poke_icon"
    case clickPokeAlarmDetail = "click_poke_alarm_detail"
    case clickPokeQuit = "click_poke_quit"
    case clickPokeSendMessage = "click_poke_send_message"
    case clickPokeAnonymity = "click_poke_anonymity"
    
    // 탭 바 클릭 이벤트
    case clickNaviHome = "click_navi_home"
    case clickNaviMyPage = "click_navi_mypage"
    case clickNaviSoptamp = "click_navi_soptamp"
    case clickNaviPoke = "click_navi_poke"
    case clickNaviAppjamtamp = "click_navi_appjamtamp"

    // 홈 뷰 이벤트
    case viewAppHome = "view_apphome"
    case viewNotificationDetail = "view_notification_detail"
    case viewNotificationList = "view_notification_list"    
    
    // 콕 찌르기 뷰 이벤트
    case viewPokeOnboarding = "view_poke_onboarding"
    case viewPokeOnboardingFragment = "view_poke_onboarding_fragment"
    case viewPokeMain = "view_poke_main"
    case viewPokeAlarmDetail = "view_poke_alarm_detail"
    case viewPokeFriend = "view_poke_friend"
    case viewPokeFriendDetail = "view_poke_friend_detail"            
    
    // 박수 이벤트
    case clickUpdateClap = "click_update_clap"
    case getGetImageZoom = "click_get_image_zoom"
    case clickClappersList = "click_clappersList"
    case clickFeedMission = "click_feed_mission"
    
    // 솝탬프 이벤트
    case viewAllranking = "view_allranking"
    case viewPartRanking = "view_partranking"
    case clickAllrankingMyranking = "click_allranking_myranking"
    case clickClapperlist = "click_clapperlist"
    case clickPartrankingMyranking = "click_partranking_myranking"
    
    
    // 솝레터 이벤트
    case viewSoptletterOnboarding = "view_soptletter_onboarding"
    case viewSoptletterNickname = "view_soptletter_nickname"
    case clickSoptletterStartButton = "click_soptletter_start_button"
    case viewSoptletterMain = "view_soptletter_main"
    case clickWriteSoptletter = "click_write_soptletter"
    case clickDoneWriteSoptletter = "click_done_write_soptletter"
    case clickSoptletterDetail = "click_soptletter_detail"
    case clickEditSoptletter = "click_edit_soptletter"
    case clickDoneEditSoptletter = "click_done_edit_soptletter"
    case clickSoptletterLikeButton = "click_soptletter_like_button"
    case clickDeleteSoptletter = "click_delete_soptletter"
    case clickExportSoptletter = "click_export_soptletter"
    case clickDoneExportSoptletter = "click_done_export_soptletter"
    case clickQuitSoptletter = "click_quit_soptletter"
    
    // 마이페이지 이벤트
    case viewMypageMain = "view_mypage_main"
    case clickProfileEditButton = "click_profile_edit_button"
    case clickMypageSoptlog = "click_mypage_soptlog"
    case viewSoptlogMain = "view_soptlog_main"
    case clickMypageFeedback = "click_mypage_feedback"
    case clickMypageNotification = "click_mypage_notification"
    case clickMypageEditStatusmessage = "click_mypage_edit_statusmessage"
    case clickDoneEditStatusmessage = "click_done_edit_statusmessage"
    case clickMypageResetStamp = "click_mypage_reset_stamp"
    case clickDoneLogout = "click_done_logout"
    case clickMypageQuit = "click_mypage_quit"
}
