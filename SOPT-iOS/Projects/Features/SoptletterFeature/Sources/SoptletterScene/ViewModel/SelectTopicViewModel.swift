//
//  SelectTopicViewModel.swift
//  SoptletterFeature
//
//  Created by 최주리 on 7/3/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import BaseFeatureDependency
import SoptletterFeatureInterface

final class SelectTopicViewModel: SelectTopicViewModelType {
    
    var onCellTap: ((SoptletterTopicModel) -> Void)?
    var onNaviBackTap: (() -> Void)?
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: SoptletterUseCase
    private var cancelBag = CancelBag()
    
    private var fetchTopicTask: Task<Void, Never>?
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
        let cellTap: Driver<SoptletterTopicModel>
    }
    
    public struct Output {
        var topicsSubject = PassthroughSubject<SoptletterTopicListModel, Never>()
    }
    
    init(coordinator: Coordinator, useCase: SoptletterUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    deinit {
        fetchTopicTask?.cancel()
        fetchTopicTask = nil
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        bindOutput(output: output)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchTopics()
            }.store(in: cancelBag)
        
        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.cellTap
            .withUnretained(self)
            .sink { owner, topic in
                owner.onCellTap?(topic)
            }.store(in: cancelBag)
        
        return output
    }
}

private extension SelectTopicViewModel {
    func bindOutput(output: Output) {
        useCase.topicsResult
            .asDriver()
            .withUnretained(self)
            .sink { owner, topics in
                output.topicsSubject.send(topics)
            }.store(in: cancelBag)
    }
    
    func fetchTopics() {
        fetchTopicTask?.cancel()
        fetchTopicTask = Task {
            do {
                try await useCase.fetchTopics()
            } catch {
                // TODO: 에러처리
            }
        }
    }
}
