//
//  MyPageItem.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

enum MyPageItemType: Hashable {
    /// Service Policy 섹션
    case privacyPolicy
    case termsOfUse
    case sendFeedback
    
    /// Notification Settings 섹션
    case setNotification
    
    /// Soptamp Settings 섹션
    case editOnelineSentence
    case resetStamp
    
    /// Etc User 섹션
    case logout
    case withdrawal
    
    /// Etc Visitor 섹션
    case login
    
    var title: String {
        switch self {
        case .privacyPolicy:
            return I18N.MyPage.ServicePolicySection.privacyPolicy
        case .termsOfUse:
            return I18N.MyPage.ServicePolicySection.termsOfUse
        case .sendFeedback:
            return I18N.MyPage.ServicePolicySection.sendFeedback
        case .setNotification:
            return I18N.MyPage.NotificationSection.setNotification
        case .editOnelineSentence:
            return I18N.MyPage.SoptampSection.editOnelineSentence
        case .resetStamp:
            return I18N.MyPage.SoptampSection.resetStamp
        case .logout:
            return I18N.MyPage.EtcSection.logout
        case .withdrawal:
            return I18N.MyPage.EtcSection.withdrawal
        case .login:
            return I18N.MyPage.EtcSection.login
        }
    }
}

struct MyPageItem: Hashable {
    let id = UUID()
    let type: MyPageItemType
    let hasArrow: Bool = true
    
    var title: String {
        return type.title
    }
}
