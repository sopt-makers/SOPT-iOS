//
//  PokeFriendRandomUserModel.swift
//  Domain
//
//  Created by sejin on 12/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeFriendRandomUserModel {
  public let randomInfoList: [PokeRandomInfoListModel]

  public init(randomInfoList: [PokeRandomInfoListModel]) {
    self.randomInfoList = randomInfoList
  }
}

public struct PokeRandomInfoListModel {
  public let randomType: PokeRandomUserType?
  public let randomTitle: String
  public let userInfoList: [PokeUserModel]

  public init(randomType: PokeRandomUserType?, randomTitle: String, userInfoList: [PokeUserModel]) {
    self.randomType = randomType
    self.randomTitle = randomTitle
    self.userInfoList = userInfoList
  }
}
