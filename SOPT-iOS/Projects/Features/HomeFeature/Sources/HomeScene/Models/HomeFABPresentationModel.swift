//
//  HomeFABPresentationModel.swift
//  HomeFeature
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain

struct HomeFABPresentationModel {
    
    let imageUrl: String
    let url: String
    let actionButtonName: String
    let extenedFAButton: ExtendedFAButton
    let collapsedFAButton: CollapsedFAButton
    
    struct ExtendedFAButton {
        let title: String
        let subTitle: String
    }
    
    struct CollapsedFAButton {
        let subTitle: String
    }
}

extension HomeFABModel {
    func toPresentationModel() -> HomeFABPresentationModel {
        return HomeFABPresentationModel(
            imageUrl: self.imageUrl,
            url: self.url,
            actionButtonName: self.actionButtonName,
            extenedFAButton: HomeFABPresentationModel.ExtendedFAButton(title: self.title, subTitle: self.expandedSubTitle),
            collapsedFAButton: HomeFABPresentationModel.CollapsedFAButton(subTitle: self.collapsedSubTitle))
    }
}
