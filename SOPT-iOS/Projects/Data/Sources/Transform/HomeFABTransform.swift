//
//  HomeFABTransform.swift
//  Data
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension HomeFABResponseEntity {
    func toDomain() -> HomeFABModel {
        return HomeFABModel(
            title: self.title,
            expandedSubTitle: self.expandedSubTitle,
            collapsedSubTitle: self.collapsedSubTitle,
            actionButtonName: self.actionButtonName,
            imageUrl: self.imageUrl,
            url: self.url,
            isActive: self.isActive)
    }
}
