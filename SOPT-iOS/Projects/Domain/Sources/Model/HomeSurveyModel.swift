//
//  HomeSurveyModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 5/31/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeSurveyModel {
    public let title: String
    public let subTitle: String
    public let actionButtonName: String
    public let linkURL: String
    public let isActive: Bool
    
    public init(title: String, subTitle: String, actionButtonName: String, linkURL: String, isActive: Bool) {
        self.title = title
        self.subTitle = subTitle
        self.actionButtonName = actionButtonName
        self.linkURL = linkURL
        self.isActive = isActive
    }
}
