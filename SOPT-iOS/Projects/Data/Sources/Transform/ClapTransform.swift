//
//  ClapTransform.swift
//  Data
//
//  Created by 최주리 on 10/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Networks
import Domain

public extension ClapCountEntity {
    func toDomain() -> ClapCountModel {
        return .init(
            stampId: stampId,
            appliedCount: appliedCount,
            totalClapCount: totalClapCount
        )
  }
}
