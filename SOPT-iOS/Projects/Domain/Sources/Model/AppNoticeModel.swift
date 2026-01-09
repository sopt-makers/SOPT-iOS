//
//  AppNoticeModel.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation
import Core

public struct ForceUpdateModel: Decodable {
    public let minimumVersion: String
    public let appNotice: AppNoticeModel
}

public struct AppNoticeModel: Decodable {
    public let title: String
    public let notice: String
    public let imgUrl: String?
}

extension ForceUpdateModel {
    #warning("배포 전 최소버전 값 지정 필요")
    public static let fallbackValue: ForceUpdateModel = .init(
        minimumVersion: "4.2.3",
        appNotice: AppNoticeModel.init(title: I18N.ForceUpdate.alertTitle,
                                       notice: I18N.ForceUpdate.description,
                                       imgUrl: nil))
}
