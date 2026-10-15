//
//  AmplitudeEventType.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

// NOTE: 2026.10.11 앰플리튜드 v2 기준으로 정리된 이벤트목록입니다.

import Foundation

public enum AmplitudeEventType: String {
    
    // MARK: 홈 화면
    case viewAppHome = "view_apphome"
    case clickAlarm = "click_alarm"
    case clickAttendacne = "click_attendance"
    case clickAllCalendar = "click_all_calendar"
    
    case clickPlaygroundMember = "click_playground_member"
    case clickPlaygroundGroup = "click_playground_group"
    case clickPlaygroundProject = "click_playground_project"
    case clickCoffeeChat = "click_playground_coffee_chat"
    case clickPlaygroundCommunity = "click_playground_community"
    
    case clickSoptletterMenu = "click_soptletter_menu"
    
    case clickHotboard = "click_hotboard"
    
    case clickOfficialHomepage = "click_homepage"
    case clickYoutube = "click_youtube"
    case clickInstagram = "click_instagram"
    case clickSurveyButton = "click_survey_button"
    
    case clickToastButton = "click_toast_button"
    
    
    // MARK: GNB
    case clickNaviHome = "click_navi_home"
    case clickNaviMyPage = "click_navi_mypage"
    case clickNaviSoptamp = "click_navi_soptamp"
    case clickNaviPoke = "click_navi_poke"
    case clickNaviAppjamtamp = "click_navi_appjamtamp"
    case clickPlusButton = "click_plus_button"

    
    // MARK: 푸시 알림
    case clickLink = "click_link_button"
    case clickReadAll = "click_allread_button"
    case clickNotificationItem = "click_notification_item"
    case viewNotificationList = "view_notification_list"
    case receivedPush = "received_push"
    case clickPush = "click_push"
    case viewNotificationDetail = "view_notification_detail"
    
    
    // MARK: 콕찌르기
    case clickPokeIcon = "click_poke_icon"
    case clickMemberProfile = "click_memberprofile"
    case clickPokeAlarmDetail = "click_poke_alarm_detail"
    case viewPokeOnboarding = "view_poke_onboarding"
    case viewPokeOnboardingFragment = "view_poke_onboarding_fragment"
    case viewPokeMain = "view_poke_main"
    case viewPokeFriend = "view_poke_friend"
    case viewPokeFriendDetail = "view_poke_friend_detail"
    case viewPokeAlarmDetail = "view_poke_alarm_detail"
    case clickPokeSendMessage = "click_poke_send_message"
    case clickPokeAnonymity = "click_poke_anonymity"
    
    
    // MARK: 솝탬프
    case clickUpdateClap = "click_update_clap"
    case clickGetImageZoom = "click_get_image_zoom"
    case clickFeedMission = "click_feed_mission"
    case viewAllranking = "view_allranking"
    case viewPartRanking = "view_partranking"
    case clickAllrankingMyranking = "click_allranking_myranking"
    case clickPartrankingMyranking = "click_partranking_myranking"
    case clickClapperlist = "click_clapperlist"

    
    // MARK: 솝레터
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
    
    // MARK: 마이페이지 이벤트
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
