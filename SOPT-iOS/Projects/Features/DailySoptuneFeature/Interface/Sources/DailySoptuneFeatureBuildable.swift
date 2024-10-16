//
//  DailySoptuneFeatureBuildable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

public protocol DailySoptuneFeatureBuildable {
    func makeDailySoptuneResultVC(resultModel: DailySoptuneResultModel) -> DailySoptuneResultPresentable
    func makeDailySoptuneMainVC() -> DailySoptuneMainPresentable
    func makeDailySoptuneCardVC(cardModel: DailySoptuneCardModel) -> DailySoptuneCardPresentable
}
