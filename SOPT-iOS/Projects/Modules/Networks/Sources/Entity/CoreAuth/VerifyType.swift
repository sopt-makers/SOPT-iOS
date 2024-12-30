//
//  VerifyType.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation


public enum VerifyType: String, Encodable {
    case register = "REGISTER"
    case change = "CHANGE"
    case search = "SEARCH"
}
