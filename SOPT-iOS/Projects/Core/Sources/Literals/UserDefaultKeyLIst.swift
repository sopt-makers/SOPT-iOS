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
        @UserDefaultWrapper<String>(key: "deviceToken") public static var deviceToken
        @UserDefaultWrapper<String>(key: "endpointArnForSNS") public static var endpointArnForSNS
        @UserDefaultWrapper<Int>(key: "userId") public static var userId
    }
    
    public struct User {
        @UserDefaultWrapper<String>(key: "sentence") public static var sentence
    }
    
    public struct AppNotice {
        @UserDefaultWrapper<String>(key: "checkedAppVersion") public static var checkedAppVersion
    }
}
