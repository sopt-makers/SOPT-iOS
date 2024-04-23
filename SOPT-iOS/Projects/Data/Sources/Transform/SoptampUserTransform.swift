//
//  SoptampUserTransform.swift
//  Data
//
//  Created by Ian on 4/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension SoptampUserEntity {
  public func toDomain() -> SoptampUserModel {
    return SoptampUserModel(
      nickname: self.nickname,
      profileMessage: self.profileMessage,
      points: self.points
    )
  }
}
