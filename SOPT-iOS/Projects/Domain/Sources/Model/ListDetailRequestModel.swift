//
//  ListDetailRequestModel.swift
//  Domain
//
//  Created by 양수빈 on 2022/12/05.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

public struct ListDetailRequestModel {
  public let missionId: Int
  public let content: String
  public let activityDate: String
  
  public var imgURL: String?
  
  public init(
    missionId: Int,
    content: String,
    activityDate: String
  ) {
    self.missionId = missionId
    self.content = content
    self.activityDate = activityDate
  }
}

extension ListDetailRequestModel {
  public mutating func updateImgUrl(to imageUrl: String) -> Self {
    self.imgURL = imageUrl
    
    return self
  }
}
