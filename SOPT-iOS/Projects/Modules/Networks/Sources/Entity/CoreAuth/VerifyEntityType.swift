//
//  VerifyType.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum VerifyEntityType: String, Encodable {
    case register = "REGISTER"
    case searchSocialAccount = "SEARCH_SOCIAL_PLATFORM"
    case changeSocialAccount = "CHANGE_SOCIAL_PLATFORM"
    case changePhoneNumber = "CHANGE_PHONE_NUMBER"
}
