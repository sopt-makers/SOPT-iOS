//
//  PokeRandomListEntity.swift
//  Networks
//
//  Created by Ian on 6/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - PokeRandomListEntity
public struct PokeRandomListEntity {
  public let randomInfoList: [PokeRandomUserInfoEntity]
}

extension PokeRandomListEntity: Decodable {
  enum CodingKeys: String, CodingKey {
    case randomInfoList
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.randomInfoList = try container.decode([PokeRandomUserInfoEntity].self, forKey: .randomInfoList)
  }
}

// MARK: - PokeRandomUserInfoEntity
public struct PokeRandomUserInfoEntity {
  public let randomType: PokeRandomUserEntityType
  public let randomTitle: String
  public let userInfoList: [PokeUserEntity]
}

extension PokeRandomUserInfoEntity: Decodable {
  enum CodingKeys: String, CodingKey {
    case randomType, randomTitle, userInfoList
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.randomType = try container.decode(PokeRandomUserEntityType.self, forKey: .randomType)
    self.randomTitle = try container.decode(String.self, forKey: .randomTitle)
    self.userInfoList = try container.decode([PokeUserEntity].self, forKey: .userInfoList)
  }
}

