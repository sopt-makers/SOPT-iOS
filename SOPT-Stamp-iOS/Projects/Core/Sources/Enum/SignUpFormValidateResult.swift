//
//  SignUpFormValidateResult.swift
//  Core
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum SignUpFormValidateResult {
    case valid(text: String)
    case invalid(text: String)
}
