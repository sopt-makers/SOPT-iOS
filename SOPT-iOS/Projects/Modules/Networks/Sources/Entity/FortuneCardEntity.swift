//
//  FortuneCardEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - Entity

public struct FortuneCardEntity: Codable {
    public let name, description, imageColorCode: String
    public let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name, description, imageColorCode
        case imageURL = "imageUrl"
    }
}
