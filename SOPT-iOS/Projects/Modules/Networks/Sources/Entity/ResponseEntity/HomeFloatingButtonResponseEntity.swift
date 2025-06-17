//
//  HomeFloatingButtonResponseEntity.swift
//  Networks
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeFloatingButtonResponseEntity: Decodable {
    public let title: String
    public let expandedSubTitle: String
    public let collapsedSubTitle: String
    public let actionButtonName: String
    public let imageUrl: String
    public let url: String
    public let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, expandedSubTitle, actionButtonName, imageUrl, isActive
        case collapsedSubTitle = "collapsedSubtitle"
        case url = "linkUrl"
    }
}
