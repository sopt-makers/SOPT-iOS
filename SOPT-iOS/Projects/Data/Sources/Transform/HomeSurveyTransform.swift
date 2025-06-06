//
//  HomeSurveyTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 5/31/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeSurveyResponseEntity {
    public func toDomain() -> HomeSurveyModel {
        return HomeSurveyModel(
            title: self.title,
            subTitle: self.subTitle,
            actionButtonName: self.actionButtonName,
            linkURL: self.linkURL,
            isActive: self.isActive
        )
    }
}
