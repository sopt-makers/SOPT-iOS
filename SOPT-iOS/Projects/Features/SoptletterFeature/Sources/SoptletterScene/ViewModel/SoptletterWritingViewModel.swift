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
import Domain
import BaseFeatureDependency
import SoptletterFeatureInterface

public final class SoptletterWritingViewModel: SoptletterWritingViewModelType {

    // MARK: - SoptletterCoordinatable

    public var onNaviBackTap: (() -> Void)?
    public var onSubmitSuccess: (() -> Void)?

    // MARK: - Properties

    private let coordinator: AnyCoordinatorObject
    private let useCase: SoptletterUseCase
    private var cancelBag = CancelBag()
    private var submitTask: Task<Void, Never>?
    // TODO: 주제 선정 화면 연동 시 실제 topicId로 교체
    private let topicId = 1

    // MARK: - Inputs

    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
        let textChanged: Driver<String>
        let submitTap: Driver<Void>
    }

    // MARK: - Outputs

    public struct Output {
        let isSubmitEnabled = CurrentValueSubject<Bool, Never>(false)
    }

    // MARK: - Init

    public init(coordinator: Coordinator, useCase: SoptletterUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    deinit {
        submitTask?.cancel()
    }
}

extension SoptletterWritingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        var currentText = ""

        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)

        input.textChanged
            .withUnretained(self)
            .sink { owner, text in
                currentText = text
                output.isSubmitEnabled.send(owner.useCase.isWritable(content: text))
            }.store(in: cancelBag)

        input.submitTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.submitTask?.cancel()
                owner.submitTask = Task {
                    do {
                        try await owner.useCase.writeMessage(topicId: owner.topicId, content: currentText)
                        await MainActor.run { owner.onSubmitSuccess?() }
                    } catch {
                        await MainActor.run {
                            ToastUtils.showMDSToast(type: .alert, text: I18N.Soptletter.submitFailure)
                        }
                    }
                }
            }.store(in: cancelBag)

        return output
    }
}
