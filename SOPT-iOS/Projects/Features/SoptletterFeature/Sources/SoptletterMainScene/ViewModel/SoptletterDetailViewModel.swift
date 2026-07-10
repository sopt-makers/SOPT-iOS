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
    }
    
    public struct Output {
        let soptletterMessage = PassthroughSubject<SoptletterDetailMessageModel, Never>()
        let soptletterEditCompleted = PassthroughSubject<Void, Never>()
        let soptletterDeleteCompleted = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties
    
    private var submitTask: Task<Void, Never>?
    public var onNaviBackTap: (() -> Void)?
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
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchMessages(output: output)
            }.store(in: cancelBag)
                
        input.editCompleteButtonTap
            .withUnretained(self)
            .sink { owner, content in
                owner.submitTask?.cancel()
                owner.submitTask = Task { [weak self] in
                    do {
                        try await owner.useCase.editMessage(messageId: owner.messageId, topicId: owner.topicId, content: content)
                        output.soptletterEditCompleted.send()
                        owner.onEditCompleted?()
                    } catch is CancellationError {
                        return
                    } catch {
                        await self?.onError?()
                    }
                }
            }
            .store(in: cancelBag)

        input.deleteButtonTap
            .withUnretained(self)
            .sink { owner, content in
                AlertUtils.presentAlertVC(type: .titleDescription, title: I18N.Soptletter.Detail.deleteAlertTitle, description: I18N.Soptletter.Detail.deleteAlertDescription, customButtonTitle: I18N.Soptletter.Detail.deleteButtonTitle, customAction: {
                    owner.deleteMessage(output: output, content: content)
                })
            }
            .store(in: cancelBag)
        
        return output
    }
}

extension SoptletterDetailViewModel {
    public func fetchMessages(output: Output) {
        submitTask?.cancel()
        submitTask = Task { [weak self] in
            guard let self else { return }
            do {
                let messages = try await self.useCase.fetchSoptletterMessage(messageId: self.messageId, topicId: self.topicId)
                await MainActor.run { output.soptletterMessage.send(messages) }
            } catch is CancellationError {
                return
            } catch {
                await self.onError?()
            }
        }
    }

    private func deleteMessage(output: Output, content: String) {
        submitTask?.cancel()
        submitTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await self.useCase.deleteMessage(messageId: self.messageId, topicId: self.topicId)
                output.soptletterDeleteCompleted.send()
                self.onDeleteCompleted?()
            } catch is CancellationError {
                return
            } catch {
                await self.onError?()
            }
        }
    }
}
