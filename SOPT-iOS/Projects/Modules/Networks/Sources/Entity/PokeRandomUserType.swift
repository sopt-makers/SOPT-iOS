//
//  PokeRandomUserEntityType.swift
//  Networks
//
//  Created by Ian on 6/2/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum PokeRandomUserEntityType: String, Decodable {
  case all = "ALL"
  case generation = "GENERATION"
  case mbti = "MBTI"
  case sojuCapacity = "SOJU_CAPACITY"
}
