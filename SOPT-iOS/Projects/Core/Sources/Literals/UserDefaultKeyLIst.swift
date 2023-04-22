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
    }
    
    public struct AppNotice {
        @UserDefaultWrapper<String>(key: "checkedAppVersion") public static var checkedAppVersion
    }
}

extension UserDefaultKeyList {
    public static func clearAllUserData() {
        UserDefaultKeyList.Auth.appAccessToken = nil
        UserDefaultKeyList.Auth.appRefreshToken = nil
        UserDefaultKeyList.Auth.playgroundToken = nil
        UserDefaultKeyList.Auth.isActiveUser = false
        clearSoptampUserData()
    }

    public static func clearSoptampUserData() {
        UserDefaultKeyList.User.soptampName = nil
        UserDefaultKeyList.User.sentence = nil
    }
}

extension UserDefaultKeyList.Auth {
    public static func getUserType() -> UserType {
        guard appAccessToken != nil else {
            return UserType.visitor
        }
        
        guard appAccessToken != "" else {
            return UserType.unregisteredInactive
        }
        
        return getUserActivation()
        ? UserType.active
        : UserType.inactive
    }
    
    public static func getUserActivation() -> Bool {
        UserDefaultKeyList.Auth.isActiveUser ?? false
    }
}
