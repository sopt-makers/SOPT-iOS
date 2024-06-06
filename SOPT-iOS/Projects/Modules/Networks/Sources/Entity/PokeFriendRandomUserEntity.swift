//
//  PokeFriendRandomUserEntity.swift
//  Networks
//
//  Created by sejin on 12/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeFriendRandomUserEntity: Codable {
  public let randomInfoList: [PokeRandomInfoListEntity]
}

public struct PokeRandomInfoListEntity: Codable {
  public let randomType, randomTitle: String
  public let userInfoList: [PokeUserEntity]
}
