//
//  FirebaseService.swift
//  Core
//
//  Created by 강윤서 on 7/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import FirebaseCore
import FirebaseCrashlytics

public final class Firebase {}

extension Firebase {
    public static func configure() {
        FirebaseApp.configure()
    }
    
    public static func configureCrashlytics() {
        // 식별 정보 셋팅
        Crashlytics.crashlytics().setCustomKeysAndValues(CrashlyticsPropertyKeys.defaultValues)

        // 미전송된 리포트가 있을 경우 전송
        Crashlytics.crashlytics().sendUnsentReports()
    }
}
