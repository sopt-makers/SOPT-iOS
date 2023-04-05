//
//  AppNoticeEntity.swift
//  Network
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct AppNoticeEntity: Codable {
    public let notice, iOSForceUpdateVersion, iOSAppVersion, androidForceUpdateVersion: String
    public let androidAppVersion: String
    public let imgURL: String?

    enum CodingKeys: String, CodingKey {
        case notice
        case iOSForceUpdateVersion = "iOS_force_update_version"
        case iOSAppVersion = "iOS_app_version"
        case androidForceUpdateVersion = "android_force_update_version"
        case androidAppVersion = "android_app_version"
        case imgURL = "img_url"
    }
}
