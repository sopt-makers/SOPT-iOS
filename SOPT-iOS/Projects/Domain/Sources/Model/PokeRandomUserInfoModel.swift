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
  public var userInfoList: [PokeUserModel]
  
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

extension PokeRandomUserInfoModel {
  mutating public func updateAfterPoked(with pokedResult: PokeUserModel) {
    guard let index = userInfoList.firstIndex(where: { $0.userId == pokedResult.userId }) else { return }
    
    self.userInfoList[index] = pokedResult
  }
}

