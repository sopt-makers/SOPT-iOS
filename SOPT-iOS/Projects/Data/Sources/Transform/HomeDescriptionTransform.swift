//
//  HomeDescriptionTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeDescriptionEntity {
    public func toDomain() -> HomeDescriptionModel {
        return HomeDescriptionModel.init(description: activityDescription)
    }
}
