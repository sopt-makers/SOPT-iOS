//
//  MyPageSectionLayoutKind.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core

enum MyPageSectionLayoutKind: Int, CaseIterable {
    case profile
    case soptlogPreview
    case soptlogCheckButton
    case servicePolicy
    case notificationSettings
    case soptampSettings
    case etcUser
    case etcVisitor

    var title: String {
        switch self {
        case .profile, .soptlogPreview, .soptlogCheckButton: return ""
        case .servicePolicy: return I18N.MyPage.ServicePolicySection.title
        case .notificationSettings: return I18N.MyPage.NotificationSection.title
        case .soptampSettings: return I18N.MyPage.SoptampSection.title
        case .etcUser, .etcVisitor: return I18N.MyPage.EtcSection.title
        }
    }

    func items(userType: UserType, isAppjamtampOpen: Bool) -> [MyPageItem] {
        switch self {
        case .profile:
            return [MyPageItem(type: .profileCard)]
        case .soptlogPreview:
            var items: [MyPageItem] = []
            if userType == .active && !isAppjamtampOpen {
                items.append(MyPageItem(type: .soptlogSoptampPreview))
            }
            items.append(MyPageItem(type: .soptlogPokePreview))
            return items
        case .soptlogCheckButton:
            return [MyPageItem(type: .soptlogCheckButton)]
        case .servicePolicy:
            return [
                MyPageItem(type: .privacyPolicy),
                MyPageItem(type: .termsOfUse),
                MyPageItem(type: .sendFeedback)
            ]
        case .notificationSettings:
            return [
                MyPageItem(type: .setNotification)
            ]
        case .soptampSettings:
            return [
                MyPageItem(type: .editOnelineSentence),
                MyPageItem(type: .resetStamp)
            ]
        case .etcUser:
            return [
                MyPageItem(type: .logout),
                MyPageItem(type: .withdrawal)
            ]
        case .etcVisitor:
            return [
                MyPageItem(type: .login)
            ]
        }
    }
}
