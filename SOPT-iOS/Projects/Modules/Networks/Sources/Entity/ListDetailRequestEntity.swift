//
//  ListDetailRequestEntity.swift
//  Networks
//
//  Created by Ian on 4/13/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Network

public struct ListDetailRequestEntity {
  public let missionId: Int
  public let content: String
  public let activityDate: String
  public let imgURL: String?
  
  public init(
    missionId: Int,
    content: String,
    activityDate: String,
    imgURL: String?
  ) {
    self.missionId = missionId
    self.content = content
    self.activityDate = activityDate
    self.imgURL = imgURL
  }
}
