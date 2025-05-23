//
//  HomeFloatingButtonModel.swift
//  Domain
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeFloatingButtonModel: Decodable {
    public let title: String
    public let expandedSubTitle: String
    public let collapsedSubTitle: String
    public let actionButtonName: String
    public let imageUrl: String
    public let url: String
    public let isActive: Bool
    
    public init(title: String, expandedSubTitle: String, collapsedSubTitle: String, actionButtonName: String, imageUrl: String, url: String, isActive: Bool) {
        self.title = title
        self.expandedSubTitle = expandedSubTitle
        self.collapsedSubTitle = collapsedSubTitle
        self.actionButtonName = actionButtonName
        self.imageUrl = imageUrl
        self.url = url
        self.isActive = isActive
    }
}
