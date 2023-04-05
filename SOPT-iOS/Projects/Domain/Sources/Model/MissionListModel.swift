//
//  MissionListModel.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct MissionListModel: Codable, Hashable {
    public let id: Int
    public let title: String
    public let level: Int
    public let isCompleted: Bool
    
    public init(id: Int, title: String, level: Int, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.level = level
        self.isCompleted = isCompleted
    }
}
