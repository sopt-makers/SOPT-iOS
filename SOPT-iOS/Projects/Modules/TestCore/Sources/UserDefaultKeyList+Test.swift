//
//  UserDefaultKeyList+Test.swift
//  TestCore
//
//  Created by Junho Lee on 2023/06/09.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public extension UserDefaultKeyList {
    static func setInactiveUserForTest() {
        UserDefaultKeyList.Auth.appAccessToken = TestConfig.appAccessToken
        UserDefaultKeyList.Auth.appRefreshToken = TestConfig.appRefreshToken
        UserDefaultKeyList.Auth.isActiveUser = false
        UserDefaultKeyList.User.soptampName = "Test Name"
        UserDefaultKeyList.User.sentence = "Test Sentence"
    }
}
