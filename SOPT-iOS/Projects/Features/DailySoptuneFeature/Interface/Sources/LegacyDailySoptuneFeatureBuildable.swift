//
//  LegacyDailySoptuneFeatureBuildable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import BaseFeatureDependency

public protocol LegacyDailySoptuneFeatureBuildable {
    func makeDailySoptuneResultVC(resultModel: DailySoptuneResultModel,
                                  coordinator: Coordinator) -> DailySoptuneResultPresentable
    func makeDailySoptuneMainVC(coordinator: Coordinator) -> LegacyDailySoptuneMainPresentable
    func makeDailySoptuneCardVC(cardModel: DailySoptuneCardModel) -> LegacyDailySoptuneCardPresentable
}
