//
//  SoptletterDetailViewModel.swift
//  SoptletterFeature
//
//  Created by dev on 7/2/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import BaseFeatureDependency
import SoptletterFeatureInterface
import Domain


public final class SoptletterDetailViewModel: SoptletterDetailViewModelType {
    
    // MARK: - Input & Output
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let editButtonTap: Driver<Void>
        let deleteButtonTap: Driver<String>
        let confirmButtonTap: Driver<Void>
        let editCompleteButtonTap: Driver<String>
        let likeButtonTap: Driver<(likeByMe: Bool, isMine: Bool)>        
    }
    
    public struct Output {
        let soptletterMessage = PassthroughSubject<SoptletterDetailMessageModel, Never>()
        let soptletterEditCompleted = PassthroughSubject<Void, Never>()
        let soptletterDeleteCompleted = PassthroughSubject<Void, Never>()
        let soptletterLikeFailed = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Properties
        
    private var fetchTask: Task<Void, Never>?
    private var likeTask: Task<Void, Never>?
    private var editTask: Task<Void, Never>?
    private var deleteTask: Task<Void, Never>?
    
    public var onError: (@MainActor () -> Void)?
    public var onEditCompleted: (() -> Void)?
    public var onDeleteCompleted: (() -> Void)?
    
    private let messageId: Int
    private let topicId: Int
    private let useCase: SoptletterUseCase
    
    
    // MARK: - Initilizer
    
    public init(useCase: SoptletterUseCase, messageId: Int, topicId: Int) {
        self.messageId = messageId
        self.topicId = topicId
        self.useCase = useCase
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.editButtonTap
            .withUnretained(self)
            .sink { owner in
                AmplitudeInstance.shared.trackWithUserType(event: .clickEditSoptletter)
            }.store(in: cancelBag)
        
        input.likeButtonTap
            .withUnretained(self)
            .sink { owner, likeState in
                guard !likeState.isMine else {
                    Task { @MainActor in
                        ToastUtils.showMDSToast(type: .alert, text: I18N.Soptletter.Detail.cannotLikeOwnMessage)
                        output.soptletterLikeFailed.send(likeState.likeByMe)
                    }
                    return
                }

                owner.likeTask?.cancel()
                owner.likeTask = Task { [weak self] in
                    guard let self else { return }
                    do {
                        if likeState.likeByMe {
                            try await self.useCase.likeMessage(messageId: self.messageId, topicId: self.topicId)
                        } else {
                            try await self.useCase.unlikeMessage(messageId: self.messageId, topicId: self.topicId)
                        }
                    } catch is CancellationError {
                        return
                    } catch {
                        await MainActor.run {
                            output.soptletterLikeFailed.send(likeState.likeByMe)
                        }
                        await self.onError?()
                    }
                }
            }.store(in: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchMessages(output: output)
            }.store(in: cancelBag)
                
        input.editCompleteButtonTap
            .withUnretained(self)
            .sink { owner, content in
                owner.editTask?.cancel()
                owner.editTask = Task { [weak self] in
                    guard let self else { return }
                    do {
                        try await self.useCase.editMessage(messageId: self.messageId, topicId: self.topicId, content: content)
                        await MainActor.run {
                            output.soptletterEditCompleted.send()
                            self.onEditCompleted?()
                        }
                    } catch is CancellationError {
                        return
                    } catch {
                        await MainActor.run { self.onError?() }
                    }
                    
                    AmplitudeInstance.shared.trackWithUserType(event: .clickDoneEditSoptletter)
                }
            }
            .store(in: cancelBag)

        input.deleteButtonTap
            .withUnretained(self)
            .sink { owner, content in
                AlertUtils.presentAlertVC(type: .danger(primary: .init(I18N.Soptletter.Detail.deleteButtonTitle)), title: I18N.Soptletter.Detail.deleteAlertTitle, description: I18N.Soptletter.Detail.deleteAlertDescription, customAction: {
                    owner.deleteMessage(output: output, content: content)
                })
                AmplitudeInstance.shared.trackWithUserType(event: .clickDeleteSoptletter)
            }
            .store(in: cancelBag)
        
        return output
    }
}

extension SoptletterDetailViewModel {
    private func deleteMessage(output: Output, content: String) {
        deleteTask?.cancel()
        deleteTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await useCase.deleteMessage(messageId: messageId, topicId: topicId)
                await MainActor.run {
                    output.soptletterDeleteCompleted.send()
                    self.onDeleteCompleted?()
                }
            } catch is CancellationError {
                return
            } catch {
                await MainActor.run { self.onError?() }
            }
        }
    }

    public func fetchMessages(output: Output) {
        fetchTask?.cancel()
        fetchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let messages = try await useCase.fetchSoptletterMessage(messageId: messageId, topicId: topicId)
                await MainActor.run { output.soptletterMessage.send(messages) }
            } catch is CancellationError {
                return
            } catch {
                await MainActor.run { self.onError?() }
            }
        }
    }
}
