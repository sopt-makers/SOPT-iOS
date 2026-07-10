//
//  SoptletterMainViewModel.swift
//  SoptletterFeature
//
//  Created by dev on 6/30/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import BaseFeatureDependency
import SoptletterFeatureInterface
import Domain

public final class SoptletterMainViewModel: SoptletterMainViewModelType {

    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let writeButtonTap: Driver<Void>
        let downloadButtonTap: Driver<Void>
        let reportButtonTap: Driver<Void>
        let postItCellTap: Driver<(messageId: Int, topicId: Int)>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let soptletterMessages = PassthroughSubject<SoptletterItemModel, Never>()
    }
    
    private let useCase: SoptletterUseCase
    private let coordinator: AnyCoordinatorObject
    private var submitTask: Task<Void, Never>?
    private let topicId: Int
    
    private var cancelBag = CancelBag()
    
    public var onNaviBackTap: (() -> Void)?
    public var onWriteTap: (() -> Void)?
    public var onPostItTap: (() -> Void)?
    public var onDownloadTap: (() -> Void)?
    public var onReportTap: (() -> Void)?
    public var onCellTap: ((Int, Int) -> Void)?
    public var onError: (() -> Void)?
    
    private let refreshTriggerSubject = PassthroughSubject<Void, Never>()
    
    public init(coordinator: Coordinator, useCase: SoptletterUseCase, topicId: Int = 1) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.topicId = topicId
    }
}

extension SoptletterMainViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        refreshTriggerSubject
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchMessages(output: output)
            }.store(in: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchMessages(output: output)
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.writeButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onWriteTap?()
            }.store(in: cancelBag)
        
        input.downloadButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onDownloadTap?()
            }.store(in: cancelBag)
        
        input.reportButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onReportTap?()
            }.store(in: cancelBag)
        
        input.postItCellTap
            .withUnretained(self)
            .sink { owner, model in
                owner.onCellTap?(model.messageId, model.topicId)
            }.store(in: cancelBag)
        
        return output
    }
}

extension SoptletterMainViewModel {
    public func fetchMessages(output: Output) {
        submitTask?.cancel()
        submitTask = Task {
            do {
                let result = try await useCase.fetchSoptletterMessages(topicId: topicId, cursor: nil, size: nil)
                await MainActor.run {
                    output.soptletterMessages.send(result)
                }
            } catch is CancellationError {
                return
            } catch {
                onError?()
            }
        }
    }
    
    public func refreshMessagesTrigger() {
        refreshTriggerSubject.send()
    }
}
