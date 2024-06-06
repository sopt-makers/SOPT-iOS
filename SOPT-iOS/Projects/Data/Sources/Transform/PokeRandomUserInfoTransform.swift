//
//  PokeRandomUserInfoTransform.swift
//  Data
//
//  Created by Ian on 6/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Networks
import Domain

extension PokeRandomUserInfoEntity {
  public func toDomain() -> PokeRandomUserInfoModel {
    PokeRandomUserInfoModel(
      randomType: self.randomType.toDomain(),
      randomTitle: self.randomTitle,
      userInfoList: self.userInfoList.map { $0.toDomain() }
    )
  }
}

extension PokeRandomUserEntityType {
  public func toDomain() -> PokeRandomUserType {
    switch self {
    case .all: return .all
    case .generation: return .generation
    case .mbti: return .mbti
    case .sojuCapacity: return .sojuCapacity
    case .university: return .university
    }
  }
}
