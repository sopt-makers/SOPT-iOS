//
//  HomeFABResponseEntity.swift
//  Networks
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeFABResponseEntity: Decodable {
    public var title: String
    public var expandedSubTitle: String
    public var collapsedSubTitle: String
    public var actionButtonName: String
    public var imageUrl: String
    public var url: String
    public var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, expandedSubTitle, collapsedSubTitle, actionButtonName, imageUrl
        case url = "linkUrl"
        case isActive = "active"
    }
}
