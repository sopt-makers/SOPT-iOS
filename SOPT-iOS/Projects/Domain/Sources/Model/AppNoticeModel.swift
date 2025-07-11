//
//  AppNoticeModel.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct ForceUpdateModel: Decodable {
    public let minimumVersion: String
    public let appNotice: AppNoticeModel
}

public struct AppNoticeModel: Decodable {
    public let notice: String
    public let imgUrl: String?
}
