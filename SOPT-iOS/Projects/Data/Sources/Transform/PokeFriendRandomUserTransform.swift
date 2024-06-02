//
//  PokeFriendRandomUserTransform.swift
//  Data
//
//  Created by sejin on 12/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension PokeFriendRandomUserEntity {
    public func toDomain() -> PokeFriendRandomUserModel {
      return PokeFriendRandomUserModel(randomInfoList: randomInfoList.map { $0.toDomain() })
    }
}

extension PokeRandomInfoListEntity {
  public func toDomain() -> PokeRandomInfoListModel {
    return .init(randomType: PokeRandomUserType(rawValue: randomType), randomTitle: randomTitle, userInfoList: userInfoList.map { $0.toDomain() })
  }
}
