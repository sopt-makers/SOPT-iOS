//
//  BottomSheetConfiguration.swift
//  BaseFeatureDependency
//
//  Created by Ian on 12/2/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public struct BottomSheetConfiguration {
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let preferredCornerRadius: CGFloat
    let detents: [UISheetPresentationController.Detent]
}

extension BottomSheetConfiguration {
    public static func `default`() -> Self {
        .init(
            prefersScrollingExpandsWhenScrolledToEdge: true,
            preferredCornerRadius: 16.f,
            detents: [
                .custom { context in context.maximumDetentValue * 0.6 },
                .large()
            ]
        )
    }
}
