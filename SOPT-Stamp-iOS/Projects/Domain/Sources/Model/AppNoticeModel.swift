//
//  AppNoticeModel.swift
//  Domain
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct AppNoticeModel {
    public let notice, forceUpdateVersion, recommendVersion: String
    public let imgURL: String?
    public var isForced: Bool?
    public var withError: Bool = false
    
    public init(notice: String, forceUpdateVersion: String, recommendVersion: String, imgURL: String?) {
        self.notice = notice
        self.forceUpdateVersion = forceUpdateVersion
        self.recommendVersion = recommendVersion
        self.imgURL = imgURL
    }
    
    public init(withError: Bool) {
        self.withError = withError
        self.notice = ""
        self.forceUpdateVersion = ""
        self.recommendVersion = ""
        self.imgURL = ""
    }
    
    mutating func setForcedUpdateNotice(isForce: Bool) {
        self.isForced = isForce
    }
}
