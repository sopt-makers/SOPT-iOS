//
//  MainTransform.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension MainEntity {
    public func toDomain() -> UserMainInfoModel? {
        guard let user = user, !user.name.isEmpty else { return nil }
        return UserMainInfoModel.init(status: user.status, name: user.name, profileImage: user.profileImage, historyList: user.historyList, attendanceScore: operation?.attendanceScore, announcement: operation?.announcement, exists: exists)
    }
}

extension ServiceStateEntity {
    public func toDomain() -> ServiceStateModel {
        return ServiceStateModel(isAvailable: isAvailable)
    }
}
