//
//  HomeFloatingButtonPresentationModel.swift
//  HomeFeature
//
//  Created by 강윤서 on 5/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain

struct HomeFloatingButtonPresentationModel {
    
    let imageUrl: String
    let url: String
    let actionButtonName: String
    let extenedFloatingButton: ExtendedFloatingButton
    let collapsedFloatingButton: CollapsedFloatingButton
    
    struct ExtendedFloatingButton {
        let title: String
        let subTitle: String
    }
    
    struct CollapsedFloatingButton {
        let subTitle: String
    }
}

extension HomeFloatingButtonModel {
    func toPresentationModel() -> HomeFloatingButtonPresentationModel {
        return HomeFloatingButtonPresentationModel(
            imageUrl: self.imageUrl,
            url: self.url,
            actionButtonName: self.actionButtonName,
            extenedFloatingButton: HomeFloatingButtonPresentationModel.ExtendedFloatingButton(title: self.title, subTitle: self.expandedSubTitle),
            collapsedFloatingButton: HomeFloatingButtonPresentationModel.CollapsedFloatingButton(subTitle: self.collapsedSubTitle))
    }
}
