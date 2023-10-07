//
//  AppNoticeTransform.swift
//  Data
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension AppNoticeEntity {
    public func toDomain() -> AppNoticeModel {
        return AppNoticeModel.init(notice: self.notice, forceUpdateVersion: self.iOSForceUpdateVersion, recommendVersion: self.iOSAppVersion, imgURL: self.imgURL)
    }
}
