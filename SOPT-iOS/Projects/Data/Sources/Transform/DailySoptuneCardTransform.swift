//
//  DailySoptuneCardTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension FortuneCardEntity {
    public func toDomain() -> DailySoptuneCardModel {
        return DailySoptuneCardModel(name: name, description: description, imageURL: imageURL, imageColorCode: imageColorCode)
    }
}
