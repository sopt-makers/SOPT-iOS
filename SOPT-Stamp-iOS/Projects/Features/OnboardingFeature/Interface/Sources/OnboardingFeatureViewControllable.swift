//
//  OnboardingFeatureViewControllable.swift
//  OnboardingFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol OnboardingFeatureViewControllable: ViewControllable { }

public protocol OnboardingFeatureViewBuildable {
    func makeOnboardingVC() -> OnboardingFeatureViewControllable
}
