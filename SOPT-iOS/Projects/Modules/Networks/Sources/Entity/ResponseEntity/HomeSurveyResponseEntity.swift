//
//  HomeSurveyResponseEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 5/31/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeSurveyResponseEntity: Decodable {
    public let title: String
    public let subTitle: String
    public let actionButtonName: String
    public let linkURL: String
    public let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, subTitle, actionButtonName, isActive
        case linkURL = "linkUrl"
    }
}
