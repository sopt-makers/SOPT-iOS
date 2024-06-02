//
//  PokeRandomUserInfoModel.swift
//  Domain
//
//  Created by Ian on 6/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

public struct PokeRandomUserInfoModel {
  public let randomType: PokeRandomUserType
  public let randomTitle: String
  public let userInfoList: [PokeUserModel]
  
  public init(
    randomType: PokeRandomUserType,
    randomTitle: String,
    userInfoList: [PokeUserModel]
  ) {
    self.randomType = randomType
    self.randomTitle = randomTitle
    self.userInfoList = userInfoList
  }
}
