//
//  BottomSheetConfiguration.swift
//  BaseFeatureDependency
//
//  Created by Ian on 12/2/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

public struct BottomSheetConfiguration {
    public let prefersScrollingExpandsWhenScrolledToEdge: Bool
    public let preferredCornerRadius: CGFloat
    public let detents: [UISheetPresentationController.Detent]
  
    public init(
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        preferredCornerRadius: CGFloat = 20.f,
        detents: [UISheetPresentationController.Detent]
    ) {
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.preferredCornerRadius = preferredCornerRadius
        self.detents = detents
    }
}

extension BottomSheetConfiguration {
    public static func `default`() -> Self {
        .init(
            prefersScrollingExpandsWhenScrolledToEdge: true,
            preferredCornerRadius: 20.f,
            detents: [
                .custom { context in context.maximumDetentValue * 0.5 },
                .large()
            ]
        )
    }
    
    public static func onboarding() -> Self {
        .init(
            prefersScrollingExpandsWhenScrolledToEdge: true,
            preferredCornerRadius: 20.f,
            detents: [
                .custom { context in context.maximumDetentValue * 0.55 }
            ]
        )
    }

    
    public static func messageTemplate() -> Self {
        .init(
            prefersScrollingExpandsWhenScrolledToEdge: true,
            preferredCornerRadius: 20.f,
            detents: [
                .custom { context in context.maximumDetentValue * 0.4 }
            ]
        )
    }
}
