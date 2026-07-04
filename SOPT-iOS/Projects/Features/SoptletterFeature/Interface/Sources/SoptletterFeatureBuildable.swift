//
//  SoptletterFeatureBuildable.swift
//  SoptletterFeatureInterface
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public protocol SoptletterFeatureBuildable {
    func makeSoptletterOnboardingVC(coordinator: Coordinator) -> SoptletterOnboardingPresentable
    func makeSoptletterNicknameCheckVC(coordinator: Coordinator) -> SoptletterNicknameCheckPresentable
    func makeSoptletterWritingVC(coordinator: Coordinator) -> SoptletterWritingPresentable
    func makeSelectTopicVC(coordinator: Coordinator) -> SelectTopicPresentable
    func makeSoptletterMainVC(coordinator: Coordinator) -> SoptletterMainPresentable
    func makeSoptletterDetailVC(coordinator: Coordinator, messageId: Int, topicId: Int) -> SoptletterDetailPresentable
}
