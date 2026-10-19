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
    public var onSubmitSuccess: (@MainActor () -> Void)?
    public var onSelectTopicTap: (() -> Void)?

    // MARK: - Properties

    private let coordinator: AnyCoordinatorObject
    private let useCase: SoptletterUseCase
    private var cancelBag = CancelBag()
    private var submitTask: Task<Void, Never>?
    private var fetchNickNameTask: Task<Void, Never>?
    private let textSubject = CurrentValueSubject<String, Never>("")
    private let selectedTopicSubject = CurrentValueSubject<SoptletterTopicModel?, Never>(nil)

    // MARK: - Inputs

    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
        let textChanged: Driver<String>
        let submitTap: Driver<Void>
        let selectTopicTap: Driver<Void>
    }

    // MARK: - Outputs

    public struct Output {
        let nickName = CurrentValueSubject<String, Never>("")
        let isSubmitEnabled = CurrentValueSubject<Bool, Never>(false)
        let selectedTopicTitle = CurrentValueSubject<String?, Never>(nil)
    }

    // MARK: - Init

    public init(coordinator: Coordinator, useCase: SoptletterUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    deinit {
        submitTask?.cancel()
        fetchNickNameTask?.cancel()
    }

    public var selectedTopicId: Int? {
        selectedTopicSubject.value?.topicId
    }

    public func selectTopic(_ topic: SoptletterTopicModel) {
        selectedTopicSubject.send(topic)
    }

    private func canSubmit(text: String, topic: SoptletterTopicModel?) -> Bool {
        useCase.isWritable(content: text) && topic != nil
    }
}

extension SoptletterWritingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchNickNameTask?.cancel()
                owner.fetchNickNameTask = Task {
                    do {
                        let nickName = try await owner.useCase.getSoptletterNickName()
                        output.nickName.send(nickName)
                    } catch is CancellationError {
                        return
                    } catch {
                        // 실패하면 빈 값을 유지한다. 저장되지 않았으므로 다음 진입 때 다시 시도된다.
                    }
                }
            }.store(in: cancelBag)
        
        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)

        input.textChanged
            .withUnretained(self)
            .sink { owner, text in
                owner.textSubject.send(text)
            }.store(in: cancelBag)

        Publishers.CombineLatest(textSubject, selectedTopicSubject)
            .withUnretained(self)
            .sink { owner, state in
                output.isSubmitEnabled.send(owner.canSubmit(text: state.0, topic: state.1))
            }.store(in: cancelBag)

        selectedTopicSubject
            .map { $0?.title }
            .sink { output.selectedTopicTitle.send($0) }
            .store(in: cancelBag)

        input.submitTap
            .withUnretained(self)
            .sink { owner, _ in
                guard let topicId = owner.selectedTopicId else { return }
                
                owner.submitTask?.cancel()
                let submittedText = owner.textSubject.value
                output.isSubmitEnabled.send(false)
                owner.submitTask = Task {
                    do {
                        try await owner.useCase.writeMessage(topicId: topicId, content: submittedText)
                        await owner.onSubmitSuccess?()
                    } catch is CancellationError {
                        return
                    } catch {
                        await MainActor.run {
                            output.isSubmitEnabled.send(
                                owner.canSubmit(text: owner.textSubject.value, topic: owner.selectedTopicSubject.value)
                            )
                            ToastUtils.showMDSToast(type: .alert, text: I18N.Soptletter.submitFailure)
                        }
                    }
                }
                AmplitudeInstance.shared.trackWithUserType(event: .clickDoneWriteSoptletter)
            }.store(in: cancelBag)
        
        input.selectTopicTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onSelectTopicTap?()
            }.store(in: cancelBag)

        return output
    }
}
