//
//  SoptletterMainViewModel.swift
//  SoptletterFeature
//
//  Created by dev on 6/30/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine
import UIKit

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
        let menuButtonTap: Driver<Void>
        let postItCellTap: Driver<(messageId: Int, topicId: Int)>
        let imageProcessCompleted: Driver<(fileName: String, image: UIImage, url: URL)>
        let soptletterHeaderTap: Driver<Int>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let soptletterMessages = PassthroughSubject<SoptletterItemModel, Never>()
        let ctaInfo = PassthroughSubject<SoptletterCTAModel, Never>()
        let onDownloadConfirm = PassthroughSubject<Void, Never>()
    }
    
    private let useCase: SoptletterUseCase
    private let coordinator: AnyCoordinatorObject
    
    private var soptletterTitle: String = ""
    private var fetchMessageTask: Task<Void, Never>?
    private var fetchCTATask: Task<Void, Never>?
    private var topicId: Int
    
    private var cancelBag = CancelBag()
    
    public var onNaviBackTap: (() -> Void)?
    public var onWriteTap: (() -> Void)?
    public var onPostItTap: (() -> Void)?    
    public var onDownloadTap: ((String, UIImage, URL) -> Void)?
    public var onReportTap: (() -> Void)?
    public var onMenuTap: (() -> Void)?
    public var onCellTap: ((Int, Int) -> Void)?
    public var onError: (@MainActor () -> Void)?
    public var ctaTap: ((Int) -> Void)?
    
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
        
        output.soptletterMessages
            .withUnretained(self)
            .sink { owner, model in
                owner.soptletterTitle = model.title
            }.store(in: cancelBag)
        
        refreshTriggerSubject
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchMessages(output: output)
            }.store(in: cancelBag)
        
        input.soptletterHeaderTap
            .withUnretained(self)
            .sink { owner, topicId in
                owner.ctaTap?(topicId)
            }.store(in: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchMessages(output: output)
                owner.fetchCTA(output: output)
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.menuButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onMenuTap?()
            }.store(in: cancelBag)
        
        input.writeButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onWriteTap?()
            }.store(in: cancelBag)
        
        input.downloadButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                AlertUtils
                    .presentAlertVC(
                        type: .titleDescription,
                        title: "솝레터 출력하기",
                        description: "\(owner.soptletterTitle)의 모든 메세지가 하나의 이미지로\n 출력돼요. \n솝레터를 출력하여 우리 기수의 이야기를 공유해보세요!",
                        customButtonTitle: "출력", customAction: {
                            output.onDownloadConfirm.send(())
                        })
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
        
        input.imageProcessCompleted
            .withUnretained(self)
            .sink { owner, fileInfo in
                owner.onDownloadTap?(fileInfo.fileName, fileInfo.image, fileInfo.url)
            }.store(in: cancelBag)
        
        return output
    }
}

extension SoptletterMainViewModel {
    public func fetchMessages(output: Output) {
        fetchMessageTask?.cancel()
        fetchMessageTask = Task {
            do {
                let result = try await useCase.fetchSoptletterMessages(topicId: topicId, cursor: nil, size: nil)
                await MainActor.run {
                    output.soptletterMessages.send(result)
                }
            } catch is CancellationError {
                return
            } catch {
              await onError?()
            }
        }
    }
    
    public func fetchCTA(output: Output) {
        fetchCTATask?.cancel()
        fetchCTATask = Task {
            do {
                let result = try await useCase.fetchCTA()
                await MainActor.run {
                    output.ctaInfo.send(result)
                }
            } catch is CancellationError {
                return
            } catch {
                output.ctaInfo.send(.init(showCta: false, topicId: 0, ctaText: ""))
            }
        }
    }
    
    public func refreshMessagesTrigger() {
        refreshTriggerSubject.send()
    }
    
    public func changeTopic(_ topicId: Int) {
        self.topicId = topicId
        refreshMessagesTrigger()
    }
}
