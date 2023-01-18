//
//  AppNoticeModel.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct AppNoticeModel {
    let notice, forceUpdateVersion, recommendVersion: String
    let imgURL: String?
    
    public init(notice: String, forceUpdateVersion: String, recommendVersion: String, imgURL: String?) {
        self.notice = notice
        self.forceUpdateVersion = forceUpdateVersion
        self.recommendVersion = recommendVersion
        self.imgURL = imgURL
    }
}
