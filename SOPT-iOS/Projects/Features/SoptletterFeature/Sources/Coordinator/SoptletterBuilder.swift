//
//  SoptletterBuilder.swift
//  SoptletterFeature
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
@_exported import SoptletterFeatureInterface

public final class SoptletterBuilder {
    public init() {}
}

extension SoptletterBuilder: SoptletterFeatureBuildable {
    public func makeSoptletterOnboardingVC(coordinator: Coordinator) -> SoptletterOnboardingPresentable {
        let viewModel = SoptletterOnboardingViewModel(coordinator: coordinator)
        let viewController = SoptletterOnboardingVC(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    public func makeSoptletterNicknameCheckVC(coordinator: Coordinator) -> SoptletterNicknameCheckPresentable {
        let viewModel = SoptletterNicknameCheckViewModel(coordinator: coordinator)
        let viewController = SoptletterCheckNicknameVC(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    public func makeSoptletterWritingVC(coordinator: Coordinator) -> SoptletterWritingPresentable {
        let viewModel = SoptletterWritingViewModel(coordinator: coordinator)
        let soptletterWritingVC = SoptletterWritingVC(viewModel: viewModel)
        return (soptletterWritingVC, viewModel)
    }
}
