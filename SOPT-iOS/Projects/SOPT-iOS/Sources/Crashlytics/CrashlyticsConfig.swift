//
//  CrashlyticsConfig.swift
//  SOPT-iOS
//
//  Created by Jae Hyun Lee on 6/15/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

import Firebase

extension AppDelegate {
    func configureCrashlytics() {
        // Firebase 초기화
        FirebaseApp.configure()
        
        // 식별 정보 셋팅
        Crashlytics.crashlytics().setCustomKeysAndValues(CrashlyticsPropertyKeys.defaultValues)

        // 미전송된 리포트가 있을 경우 전송
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
