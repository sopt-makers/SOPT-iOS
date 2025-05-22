//
//  HomeFABModel.swift
//  Domain
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeFABModel: Decodable {
    public var title: String
    public var expandedSubTitle: String
    public var collapsedSubTitle: String
    public var actionButtonName: String
    public var imageUrl: String
    public var url: String
    public var isActive: Bool
    
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
