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
        let deleteButtonTap: Driver<Void>
        let confirmButtonTap: Driver<Void>
        let editCompleteButtonTap: Driver<String>
    }
    
    public struct Output {
        let soptletterMessage = PassthroughSubject<SoptletterDetailMessageModel, Never>()
        let soptletterEditResult = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties
    
    private var submitTask: Task<Void, Never>?
    public var onNaviBackTap: (() -> Void)?
    public var onError: (() -> Void)?
    
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
                owner.submitTask?.cancel()
                owner.submitTask = Task { [weak self] in
                    do {
                        let result = try await owner.useCase.fetchSoptletterMessage(messageId: owner.messageId, topicId: owner.topicId)
                        await MainActor.run { output.soptletterMessage.send(result) }                        
                    } catch is CancellationError {
                        return
                    } catch {
                        self?.onError?()
                    }
                }              
            }.store(in: cancelBag)                        
                
        input.editCompleteButtonTap
            .withUnretained(self)
            .sink { owner, content in
                owner.submitTask?.cancel()
                owner.submitTask = Task { [weak self] in
                    do {
                        try await owner.useCase.editMessage(messageId: owner.messageId, topicId: owner.topicId, content: content)         
                        output.soptletterEditResult.send()
                    } catch is CancellationError {
                        self?.onError?()
                    } catch {
                        self?.onError?()
                    }
                }
            }
            .store(in: cancelBag)
        
        // TODO: 삭제 API
        input.deleteButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                AlertUtils.presentAlertVC(type: .titleDescription, title: "솝레터 삭제하기", description: "해당 솝레터가 영구적으로 삭제되어요.\n그래도 삭제하시겠어요?", customButtonTitle: "삭제") {
                    print("삭제")
                }
            }
            .store(in: cancelBag)
        
        return output
    }
}
