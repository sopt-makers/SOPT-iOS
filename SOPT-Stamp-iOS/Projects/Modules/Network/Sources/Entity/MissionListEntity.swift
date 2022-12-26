//
//  MissionListEntity.swift
//  PresentationTests
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct MissionListEntityElement: Codable {
    public let id: Int
    public let title: String
    public let level: Int
    public let profileImage: [String]?
    public let isCompleted: Bool
}

public typealias MissionListEntity = [MissionListEntityElement]
