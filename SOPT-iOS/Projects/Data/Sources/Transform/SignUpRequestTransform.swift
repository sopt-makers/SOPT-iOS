//
//  SignUpRequestTransform.swift
//  Data
//
//  Created by 장석우 on 1/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension SignUpModel {
    func toData() -> SignUpRequestEntity {
        .init(
            name: name,
            phone: phone,
            code: code,
            authPlatform: provider.toData()
        )
    }
}
