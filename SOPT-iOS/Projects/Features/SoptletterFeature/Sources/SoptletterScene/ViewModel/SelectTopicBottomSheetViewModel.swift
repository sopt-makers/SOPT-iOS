//
//  SelectTopicBottomSheetViewModel.swift
//  SoptletterFeature
//
//  Created by 이나연 on 10/15/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import BaseFeatureDependency
import SoptletterFeatureInterface

final class SelectTopicBottomSheetViewModel: SelectTopicBottomSheetViewModelType {
    
    var onNaviBackTap: (() -> Void)?
    var onConFirmButtonTap: ((SoptletterTopicModel) -> Void)?
    var showAlert: (() -> Void)?
    var selectedTopicId: Int?
    
    private let useCase: SoptletterUseCase
    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()
    
    private var selectedTopic: SoptletterTopicModel? = nil
    private var fetchTopicTask: Task<Void, Never>?
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
        let cellTap: Driver<SoptletterTopicModel>
        let confirmButtonTap: Driver<Void>
    }
    
    public struct Output {
        var topicsSubject = PassthroughSubject<SoptletterTopicListModel, Never>()
        var initialSelectedIndex = PassthroughSubject<Int, Never>()
    }
    
    init(coordinator: Coordinator, useCase: SoptletterUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    deinit {
        fetchTopicTask?.cancel()
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchTopicTask?.cancel()
                owner.fetchTopicTask = Task {
                    do {
                        let result = try await owner.useCase.fetchTopics()
                        output.topicsSubject.send(result)
                        
                        if let id = owner.selectedTopicId,
                           let index = result.topics.firstIndex(where: { $0.topicId == id }) {
                            owner.selectedTopic = result.topics[index]
                            output.initialSelectedIndex.send(index)
                        }
                    } catch {
                        owner.showAlert?()
                    }
                }
            }.store(in: cancelBag)
        
        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.cellTap
            .withUnretained(self)
            .sink { owner, topic in
                owner.selectedTopic = topic
            }.store(in: cancelBag)
        
        input.confirmButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                guard let topic = owner.selectedTopic else { return }
                owner.onConFirmButtonTap?(topic)
            }.store(in: cancelBag)
        
        return output
    }
    
}
