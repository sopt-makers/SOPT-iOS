//
//  SoptletterCoordinator.swift
//  SoptletterFeature
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import BaseFeatureDependency
import SoptletterFeatureInterface

public final class SoptletterCoordinator: BaseCoordinator {

    // MARK: - Properties

    private let factory: SoptletterFeatureBuildable
    private weak var navigationController: UINavigationController?

    // MARK: - Init

    public init(
        navigationController: UINavigationController,
        factory: SoptletterFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }

    // MARK: - Coordinator Life Cycle

    public override func start() {
        showSoptletterWriting()
    }

    // MARK: - Navigation

    private func showSoptletterWriting() {
        var soptletterWriting = factory.makeSoptletterWritingVC(coordinator: self)

        soptletterWriting.vm.onNaviBackTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        navigationController?.pushViewController(soptletterWriting.vc, animated: true)
    }
}
