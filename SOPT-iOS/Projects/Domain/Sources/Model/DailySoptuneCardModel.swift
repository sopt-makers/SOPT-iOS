//
//  DailySoptuneCardModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct DailySoptuneCardModel: Codable {
    public let name: String
    public let description: String
    public let imageURL: String

    public init(name: String, description: String, imageURL: String) {
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
}
