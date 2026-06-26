//
//  ListDetailTransform.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension ListDetailEntity {
  public func toDomain() -> ListDetailModel {
    let profileInfo: ProfileInfo? = {
      guard let ownerNickname else { return nil }
      return ProfileInfo(name: ownerNickname, imageURL: ownerProfileImage)
    }()
    return ListDetailModel(
      image: self.images.first ?? "",
      content: self.contents,
      date: self.updatedAt ?? self.createdAt,
      stampId: self.id,
      activityDate: self.activityDate,
      clapCount: self.clapCount,
      myClapCount: self.myClapCount,
      viewCount: self.viewCount,
      isMine: self.isMine,
      profileInfo: profileInfo,
      starLevel: self.missionLevel,
      missionTitle: self.missionTitle
    )
  }
}

extension StampEntity {
  public func toDomain() -> Int {
    return self.stampId
  }
}

extension ListDetailRequestModel {
  public func toEntity() -> ListDetailRequestEntity {
    return ListDetailRequestEntity(
      missionId: self.missionId,
      content: self.content,
      activityDate: self.activityDate,
      imgURL: self.imgURL
    )
  }
}
