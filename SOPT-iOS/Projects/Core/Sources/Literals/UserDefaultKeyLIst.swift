//
//  UserDefaultKeyLIst.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct UserDefaultKeyList {
    public struct Auth {
        @UserDefaultWrapper<String>(key: "appAccessToken") public static var appAccessToken
        @UserDefaultWrapper<String>(key: "appRefreshToken") public static var appRefreshToken
        @UserDefaultWrapper<String>(key: "playgroundToken") public static var playgroundToken
        @UserDefaultWrapper<Bool>(key: "isActiveUser") public static var isActiveUser
        
        @UserDefaultWrapper<String>(key: "requestState") public static var requestState
    }
    
    public struct User {
        @UserDefaultWrapper<String>(key: "sentence") public static var sentence
        @UserDefaultWrapper<String>(key: "soptampName") public static var soptampName
        @UserDefaultWrapper<String>(key: "pushToken") public static var pushToken
        @UserDefaultWrapper<Bool>(key: "isFirstVisitToPokeView") public static var isFirstVisitToPokeOnboardingView
    }
    
    public struct AppNotice {
        @UserDefaultWrapper<String>(key: "checkedAppVersion") public static var checkedAppVersion
    }
}

extension UserDefaultKeyList {
    public static func clearAllUserData() {
        clearUserData()
        clearPushToken()
        clearSoptampUserData()
    }
    
    public static func clearUserData() {
        UserDefaultKeyList.Auth.appAccessToken = nil
        UserDefaultKeyList.Auth.appRefreshToken = nil
        UserDefaultKeyList.Auth.playgroundToken = nil
        UserDefaultKeyList.Auth.isActiveUser = nil
    }
    
    public static func clearPushToken() {
        UserDefaultKeyList.User.pushToken = nil
    }

    public static func clearSoptampUserData() {
        UserDefaultKeyList.User.soptampName = nil
        UserDefaultKeyList.User.sentence = nil
    }
}

extension UserDefaultKeyList.Auth {
    public static func getUserType() -> UserType {
        guard appAccessToken != nil, appAccessToken != "" else {
            return UserType.visitor
        }
        
        return getUserActivation()
        ? UserType.active
        : UserType.inactive
    }
    
    public static func getUserActivation() -> Bool {
        UserDefaultKeyList.Auth.isActiveUser ?? false
    }
    
    public static func hasAccessToken() -> Bool {
        guard let appAccessToken = appAccessToken, !appAccessToken.isEmpty else {
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
