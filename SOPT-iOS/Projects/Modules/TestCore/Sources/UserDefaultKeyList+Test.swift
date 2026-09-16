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
        UserDefaultKeyList.CoreAuth.accessToken = TestConfig.appAccessToken
        UserDefaultKeyList.CoreAuth.refreshToken = TestConfig.appRefreshToken
        UserDefaultKeyList.CoreAuth.isActiveUser = false
        UserDefaultKeyList.User.soptampName = "Test Name"
        UserDefaultKeyList.User.sentence = "Test Sentence"
    }
}
