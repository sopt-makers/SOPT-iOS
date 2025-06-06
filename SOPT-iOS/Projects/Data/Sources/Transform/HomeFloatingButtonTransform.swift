//
//  HomeFloatingButtonTransform.swift
//  Data
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension HomeFloatingButtonResponseEntity {
    func toDomain() -> HomeFloatingButtonModel {
        return HomeFloatingButtonModel(
            title: self.title,
            expandedSubTitle: self.expandedSubTitle,
            collapsedSubTitle: self.collapsedSubTitle,
            actionButtonName: self.actionButtonName,
            imageUrl: self.imageUrl,
            url: self.url,
            isActive: self.isActive)
    }
}
