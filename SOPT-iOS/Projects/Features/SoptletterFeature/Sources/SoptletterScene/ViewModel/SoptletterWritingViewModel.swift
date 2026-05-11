//
//  SoptletterWritingViewModel.swift
//  SoptletterFeature
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import BaseFeatureDependency
import SoptletterFeatureInterface

public final class SoptletterWritingViewModel: SoptletterWritingViewModelType {

    // MARK: - Coordinatable

    public var onNaviBackTap: (() -> Void)?

    // MARK: - Properties

    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()

    // MARK: - Inputs

    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
    }

    // MARK: - Outputs

    public struct Output {}

    // MARK: - Init

    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension SoptletterWritingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)

        return output
    }
}
