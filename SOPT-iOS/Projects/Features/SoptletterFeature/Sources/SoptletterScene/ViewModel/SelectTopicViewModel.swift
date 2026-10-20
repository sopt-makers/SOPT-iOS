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
    var showAlert: (() -> Void)?
    var onWriteButtonTap: (() -> Void)?
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: SoptletterUseCase
    private var cancelBag = CancelBag()
    
    private let refreshTriggerSubject = PassthroughSubject<Void, Never>()
    private var fetchTopicTask: Task<Void, Never>?
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
        let cellTap: Driver<SoptletterTopicModel>
        let writeButtonTap: Driver<Void>
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
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                AmplitudeInstance.shared.trackWithUserType(event: .viewSoptletterTopicList)
                owner.fetchTopics(output: output)
            }.store(in: cancelBag)
        
        refreshTriggerSubject
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchTopics(output: output)
            }.store(in: cancelBag)
        
        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
                AmplitudeInstance.shared.trackWithUserType(event: .clickQuitSoptletter)
            }.store(in: cancelBag)
        
        input.cellTap
            .withUnretained(self)
            .sink { owner, topic in
                AmplitudeInstance.shared.trackWithUserType(event: .clickSoptletterTopic)
                owner.onCellTap?(topic)
            }.store(in: cancelBag)
        
        input.writeButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onWriteButtonTap?()
            }.store(in: cancelBag)
        
        return output
    }
    
    func refreshTopicTrigger() {
        refreshTriggerSubject.send()
    }
    
    private func fetchTopics(output: Output) {
        fetchTopicTask?.cancel()
        fetchTopicTask = Task {
            do {
                let result = try await useCase.fetchTopics()
                guard !Task.isCancelled else { return }
                output.topicsSubject.send(result)
            } catch {
                showAlert?()
            }
        }
    }
}
