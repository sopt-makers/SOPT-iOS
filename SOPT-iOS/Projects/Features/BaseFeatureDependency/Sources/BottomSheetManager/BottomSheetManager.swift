//
//  BottomSheetManager.swift
//  BaseFeatureDependency
//
//  Created by Ian on 12/2/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

public class BottomSheetManager {
    private let configuration: BottomSheetConfiguration
    
    public init(
        configuration: BottomSheetConfiguration = BottomSheetConfiguration.default(),
        delegate: UISheetPresentationControllerDelegate? = nil
    ) {
        self.configuration = configuration
    }
}

extension BottomSheetManager {
    public static var `default`: BottomSheetManager {
        .init(
            configuration: .default(),
            delegate: nil
        )
    }
}

extension BottomSheetManager {
    public func present(toPresent viewController: UIViewController, on view: UIViewController?) {
        guard let sheet = viewController.sheetPresentationController else {
            return assertionFailure("Content ViewController는 modalPresent 방식으로 작업되어야 합니다.")
        }

        sheet.detents = self.configuration.detents
        sheet.preferredCornerRadius = self.configuration.preferredCornerRadius
        sheet.prefersScrollingExpandsWhenScrolledToEdge = self.configuration.prefersScrollingExpandsWhenScrolledToEdge
        
        sheet.prefersEdgeAttachedInCompactHeight = false
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = false
        sheet.largestUndimmedDetentIdentifier = .none
        sheet.prefersGrabberVisible = true
        
        view?.present(viewController, animated: true) ?? UIApplication
            .getMostTopViewController()?
            .present(viewController, animated: true)
    }
}
