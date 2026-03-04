//
//  AppjamInfoModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/9/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamInfoModel {
    public let teamNumber: String?
    public let teamName: String?
    public let isAppjamJoined: Bool
    
    public init(teamNumber: String?, teamName: String?, isAppjamJoined: Bool) {
        self.teamNumber = teamNumber
        self.teamName = teamName
        self.isAppjamJoined = isAppjamJoined
    }
}

