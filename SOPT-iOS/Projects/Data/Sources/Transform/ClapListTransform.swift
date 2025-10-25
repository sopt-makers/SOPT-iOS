//
//  ClapListTransform.swift
//  Data
//
//  Created by 성현주 on 10/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Networks
import Domain

public extension ClapListEntity {
    func toDomain() -> ClapListModel {
        return .init(
            nickname: nickname,
            profileImageUrl: profileImageUrl,
            profileMessage: profileMessage,
            clapCount: clapCount
        )
  }
}
