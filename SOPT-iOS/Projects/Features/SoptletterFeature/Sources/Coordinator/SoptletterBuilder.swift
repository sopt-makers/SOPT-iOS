//
//  SoptletterBuilder.swift
//  SoptletterFeature
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
import UIKit
@_exported import SoptletterFeatureInterface

public final class SoptletterBuilder {
    @Injected public var soptletterRepository: SoptletterRepositoryInterface

    public init() {}
}

extension SoptletterBuilder: SoptletterFeatureBuildable {
    public func makeSoptletterPrintVC(coordinator: any Coordinator, fileName: String, uiImage: UIImage, pdfURL: URL) -> SoptletterPrintPresentable {
        let viewModel = SoptletterPrintViewModel(coordinator: coordinator, pdfURL: pdfURL)
        let viewController = SoptletterPrintVC(viewModel: viewModel, uiImage: uiImage, title: fileName)
        return (viewController, viewModel)
    }
    
    public func makeSoptletterOnboardingVC(coordinator: Coordinator) -> SoptletterOnboardingPresentable {
        let viewModel = SoptletterOnboardingViewModel(coordinator: coordinator)
        let viewController = SoptletterOnboardingVC(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    public func makeSoptletterNicknameCheckVC(coordinator: Coordinator) -> SoptletterNicknameCheckPresentable {
        let useCase = DefaultSoptletterUseCase(repository: soptletterRepository)
        let viewModel = SoptletterNicknameCheckViewModel(coordinator: coordinator, useCase: useCase)
        let viewController = SoptletterCheckNicknameVC(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    public func makeSoptletterMainVC(coordinator: any BaseFeatureDependency.Coordinator, topicId: Int?, isRoot: Bool) -> SoptletterMainPresentable {
        let useCase = DefaultSoptletterUseCase(repository: soptletterRepository)
        let viewModel = SoptletterMainViewModel(coordinator: coordinator, useCase: useCase, topicId: topicId)
        let soptletterMainVC = SoptletterMainVC(viewModel: viewModel, isRoot: isRoot)
        return (soptletterMainVC, viewModel)
    }
    
    public func makeSoptletterWritingVC(coordinator: Coordinator) -> SoptletterWritingPresentable {
        let useCase = DefaultSoptletterUseCase(repository: soptletterRepository)
        let viewModel = SoptletterWritingViewModel(coordinator: coordinator, useCase: useCase)
        let soptletterWritingVC = SoptletterWritingVC(viewModel: viewModel)
        return (soptletterWritingVC, viewModel)
    }

    public func makeSelectTopicVC(coordinator: Coordinator) -> SelectTopicPresentable {
        let useCase = DefaultSoptletterUseCase(repository: soptletterRepository)
        let viewModel = SelectTopicViewModel(coordinator: coordinator, useCase: useCase)
        let vc = SelectTopicVC(viewModel: viewModel)
        return (vc, viewModel)
    }
    
    public func makeSoptletterDetailVC(coordinator: Coordinator, messageId: Int, topicId: Int) -> SoptletterDetailPresentable {
        let useCase = DefaultSoptletterUseCase(repository: soptletterRepository)
        let viewModel = SoptletterDetailViewModel(useCase: useCase, messageId: messageId, topicId: topicId)
        let vc = SoptletterDetailModalVC(viewModel: viewModel)
        return (vc, viewModel)
    }
}
