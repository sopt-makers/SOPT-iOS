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

    // MARK: - SoptletterCoordinatable

    public var onNaviBackTap: (() -> Void)?
    public var onSubmitSuccess: (() -> Void)?

    // MARK: - Properties

    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()
    private let maxCharCount = 250

    // MARK: - Inputs

    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
        let textChanged: Driver<String>
    }

    // MARK: - Outputs

    public struct Output {
        let isSubmitEnabled = CurrentValueSubject<Bool, Never>(false)
    }

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

        input.textChanged
            .withUnretained(self)
            .sink { owner, text in
                output.isSubmitEnabled.send(!text.isEmpty && text.count <= owner.maxCharCount)
            }.store(in: cancelBag)

        return output
    }
}
