//
//  DailySoptuneBuildable.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 6/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain
import BaseFeatureDependency

public protocol DailySoptuneBuildable {
    func makeDailySoptuneResultVC(resultModel: DailySoptuneResultModel,
                                  coordinator: Coordinator) -> DailySoptuneResultPresentable
    func makeDailySoptuneMainVC(coordinator: Coordinator) -> DailySoptuneMainPresentable
    func makeDailySoptuneCardVC(cardModel: DailySoptuneCardModel) -> DailySoptuneCardPresentable
}
