//
//  UserDefaultKeyLIst.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct UserDefaultKeyList {
    
    public struct CoreAuth {
        @UserDefaultWrapper<String>(key: "accessToken") public static var accessToken
        @UserDefaultWrapper<String>(key: "refreshToken") public static var refreshToken
        @UserDefaultWrapper<String>(key: "recentLogin") public static var recentLogin
        @UserDefaultWrapper<Bool>(key: "isActiveUser") public static var isActiveUser
    }
    
    public struct User {
        @UserDefaultWrapper<String>(key: "sentence") public static var sentence
        @UserDefaultWrapper<String>(key: "soptampName") public static var soptampName
        @UserDefaultWrapper<String>(key: "pushToken") public static var pushToken
        @UserDefaultWrapper<Bool>(key: "isFirstVisitToPokeView") public static var isFirstVisitToPokeOnboardingView
        @UserDefaultWrapper<Bool>(key: "isVisitedPokeMainView") public static var isVisitedPokeMainView
        @UserDefaultWrapper<Bool>(key: "isCompleteSoptletterOnboarding") public static var isCompleteSoptletterOnboarding
    }
    
    public struct AppNotice {
        @UserDefaultWrapper<String>(key: "checkedAppVersion") public static var checkedAppVersion
    }
    
    public struct Soptamp {
        @UserDefaultWrapper<String>(key: "reportUrl") public static var reportUrl
    }
}

extension UserDefaultKeyList {
    public static func clearAllUserData() {
        clearUserData()
        clearPushToken()
        clearSoptampUserData()
    }
    
    
    public static func clearUserData() {
        UserDefaultKeyList.CoreAuth.accessToken = nil
        UserDefaultKeyList.CoreAuth.refreshToken = nil
        UserDefaultKeyList.CoreAuth.isActiveUser = nil
    }
    
    public static func clearPushToken() {
        UserDefaultKeyList.User.pushToken = nil
    }

    public static func clearSoptampUserData() {
        UserDefaultKeyList.User.soptampName = nil
        UserDefaultKeyList.User.sentence = nil
    }
}

extension UserDefaultKeyList.CoreAuth {
    
    public static func getUserType() -> UserType {
        guard let accessToken = UserDefaultKeyList.CoreAuth.accessToken,
              !accessToken.isEmpty else {
            return UserType.visitor
        }
        
        return getUserActivation()
        ? UserType.active
        : UserType.inactive
    }
    
    public static func getUserActivation() -> Bool {
        UserDefaultKeyList.CoreAuth.isActiveUser ?? false
    }
    
    public static func hasAccessToken() -> Bool {
        guard let accessToken = UserDefaultKeyList.CoreAuth.accessToken,
              !accessToken.isEmpty else {
            return false
        }
        return true
    }
}

extension UserDefaultKeyList.User {
    public static func hasPushToken() -> Bool {
        guard let pushToken = pushToken, !pushToken.isEmpty else {
            return false
        }
        return true
    }
}
