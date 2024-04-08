//
//  ListDetailEntity.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct ListDetailEntity: Codable {
  public let createdAt: String
  public let updatedAt: String?
  public let id: Int
  public let contents: String
  public let images: [String]
  public let missionID: Int
  public let activityDate: String
  
  enum CodingKeys: String, CodingKey {
    case createdAt, updatedAt, id, contents, images, activityDate, missionID = "missionId"
  }
  
  public init(
    createdAt: String,
    updatedAt: String,
    id: Int,
    contents: String,
    images: [String],
    missionID: Int,
    activityDate: String
  ) {
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.id = id
    self.contents = contents
    self.images = images
    self.missionID = missionID
    self.activityDate = activityDate
  }
}

public struct StampEntity: Codable {
  public let stampId: Int
}
