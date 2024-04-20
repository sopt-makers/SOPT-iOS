//
//  SoptampUserModel.swift
//  Domain
//
//  Created by Ian on 4/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SoptampUserModel {
  public let nickname: String
  public let profileMessage: String?
  public let points: Int
  
  public init(nickname: String, profileMessage: String?, points: Int) {
    self.nickname = nickname
    self.profileMessage = profileMessage
    self.points = points
  }
}
