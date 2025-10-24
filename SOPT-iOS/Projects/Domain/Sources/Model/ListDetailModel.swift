//
//  ListDetailModel.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct ListDetailModel {
  public let image: String
  public let content: String
  public let date: String
  public let stampId: Int
  public let activityDate: String
  public let clapCount: Int
  public let myClapCount: Int?
  public let viewCount: Int
  public let isMine: Bool?
  
  public init(
    image: String,
    content: String,
    date: String,
    stampId: Int,
    activityDate: String,
    clapCount: Int,
    myClapCount: Int?,
    viewCount: Int,
    isMine: Bool?
  ) {
    self.image = image
    self.content = content
    self.date = date
    self.stampId = stampId
    self.activityDate = activityDate
    self.clapCount = clapCount
    self.myClapCount = myClapCount
    self.viewCount = viewCount
    self.isMine = isMine
  }
}
