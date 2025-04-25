//
//  HomeDescriptionModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct HomeDescriptionModel {
    public let description: String
    
    public init(description: String) {
        self.description = description
    }
}

extension HomeDescriptionModel {
    public static var defaultDescription: Self {
        return HomeDescriptionModel(description: I18N.Home.DashBoard.UserHistory.encourage)
    }
}
