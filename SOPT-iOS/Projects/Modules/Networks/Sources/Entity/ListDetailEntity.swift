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
  public let clapCount: Int
  public let myClapCount: Int?
  public let viewCount: Int
  public let isMine: Bool?
  public let teamNumber: String?
  public let teamName: String?
  public let ownerNickname: String?
  public let ownerProfileImage: String?

  enum CodingKeys: String, CodingKey {
    case createdAt
    case updatedAt
    case id
    case contents
    case images
    case activityDate
    case clapCount
    case myClapCount
    case viewCount
    case isMine
    case missionID = "missionId"
    case teamNumber
    case teamName
    case ownerNickname
    case ownerProfileImage
  }

  public init(
    createdAt: String,
    updatedAt: String?,
    id: Int,
    contents: String,
    images: [String],
    missionID: Int,
    activityDate: String,
    clapCount: Int,
    myClapCount: Int?,
    viewCount: Int,
    isMine: Bool?,
    teamNumber: String? = nil,
    teamName: String? = nil,
    ownerNickname: String? = nil,
    ownerProfileImage: String? = nil
  ) {
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.id = id
    self.contents = contents
    self.images = images
    self.missionID = missionID
    self.activityDate = activityDate
    self.clapCount = clapCount
    self.myClapCount = myClapCount
    self.viewCount = viewCount
    self.isMine = isMine
    self.teamNumber = teamNumber
    self.teamName = teamName
    self.ownerNickname = ownerNickname
    self.ownerProfileImage = ownerProfileImage
  }
}

public struct StampEntity: Codable {
  public let stampId: Int
}
