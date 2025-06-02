//
//  MyPageSectionLayoutKind.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core

enum MyPageSectionLayoutKind: Int, CaseIterable {
    case servicePolicy
    case notificationSettings
    case soptampSettings
    case etcUser
    case etcVisitor
    
    var title: String {
        switch self {
        case .servicePolicy: return I18N.MyPage.ServicePolicySection.title
        case .notificationSettings: return I18N.MyPage.NotificationSection.title
        case .soptampSettings: return I18N.MyPage.SoptampSection.title
        case .etcUser, .etcVisitor: return I18N.MyPage.EtcSection.title
        }
    }
    
    var items: [MyPageItem] {
        switch self {
        case .servicePolicy:
            return [
                MyPageItem(title: I18N.MyPage.ServicePolicySection.privacyPolicy),
                MyPageItem(title: I18N.MyPage.ServicePolicySection.termsOfUse),
                MyPageItem(title: I18N.MyPage.ServicePolicySection.sendFeedback)
            ]
        case .notificationSettings:
            return [
                MyPageItem(title: I18N.MyPage.NotificationSection.setNotification)
            ]
        case .soptampSettings:
            return [
                MyPageItem(title: I18N.MyPage.SoptampSection.editOnelineSentence),
                MyPageItem(title: I18N.MyPage.SoptampSection.resetStamp)
            ]
        case .etcUser:
            return [
                MyPageItem(title: I18N.MyPage.EtcSection.logout),
                MyPageItem(title: I18N.MyPage.EtcSection.withdrawal),
            ]
        case .etcVisitor:
            return [
                MyPageItem(title: I18N.MyPage.EtcSection.logout),
            ]
        }
    }
}
