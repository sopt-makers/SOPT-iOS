//
//  MainFeatureViewControllable.swift
//  MainFeatureInterface
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public protocol AppMyPageViewControllerable: ViewControllable { }

public protocol AppMyPageFeatureViewBuildable {
    func makeAppMyPageViewController() -> AppMyPageViewControllerable
}
