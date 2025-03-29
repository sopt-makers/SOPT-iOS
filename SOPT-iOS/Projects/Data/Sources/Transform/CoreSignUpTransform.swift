//
//  CoreSignUpRequestTransform.swift
//  Data
//
//  Created by 장석우 on 3/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Networks
import Domain

extension SignUpModel {
    func toData() -> CoreSignUpRequestEntity {
        return CoreSignUpRequestEntity(
            name: name,
            phone: phone,
            token: token,
            authPlatform: provider.toData()
        )
    }
}
