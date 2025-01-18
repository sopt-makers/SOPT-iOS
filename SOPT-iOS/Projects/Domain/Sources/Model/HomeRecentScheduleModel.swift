//
//  HomeRecentScheduleModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct HomeRecentScheduleModel: Codable {
    public var date: String
    public let type: String
    public let title: String
    
    public init(date: String, type: String, title: String) {
        self.date = date
        self.type = type
        self.title = title
    }
}
