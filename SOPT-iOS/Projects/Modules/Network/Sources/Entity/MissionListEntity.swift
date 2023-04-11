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
    public let isCompleted: Bool?
    
    public var fetchTypeHandler: Bool? = false
    
    mutating func assignCompleteFetchType(_ type: Bool) -> Self {
        self.fetchTypeHandler = type
        return self
    }
}

public typealias MissionListEntity = [MissionListEntityElement]

extension MissionListEntity {
    public mutating func assignCompleteFetchType(_ type: Bool) -> Self {
        return self.map {
            var element = $0
            return element.assignCompleteFetchType(type)
        }
    }
}
