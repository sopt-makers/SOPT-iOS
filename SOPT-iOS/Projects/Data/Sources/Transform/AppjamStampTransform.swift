//
//  AppjamStampTransform.swift
//  Data
//
//  Created by a on 6/17/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension AppJamStampResponseEntity {
    public func toDomain() -> ListDetailModel {
        ListDetailModel(
            image: self.images.first ?? "",
            content: self.contents,
            date: self.createdAt,
            stampId: self.id,
            activityDate: self.activityDate,
            clapCount: self.clapCount,
            myClapCount: 0,
            viewCount: self.viewCount,
            isMine: false,
            starLevel: 0,
            missionTitle: ""
        )
    }
}
