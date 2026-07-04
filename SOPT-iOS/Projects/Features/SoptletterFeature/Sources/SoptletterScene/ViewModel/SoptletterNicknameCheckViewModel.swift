//
//  SoptletterNicknameCheckViewModel.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/30/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import BaseFeatureDependency
import Domain
import SoptletterFeatureInterface

public final class SoptletterNicknameCheckViewModel: SoptletterNicknameCheckViewModelType {
    
    public var onNaviBackTap: (() -> Void)?
    public var onGoButtonTap: (() -> Void)?
    public var showAlert: (() -> Void)?
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: SoptletterUseCase
    
    private var cancelBag = CancelBag()
    
    private var fetchProfileTask: Task<Void, Never>?
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackTap: Driver<Void>
        let goTap: Driver<Void>
    }
    
    public struct Output {
        var profileSubject = PassthroughSubject<SoptletterProfileModel, Never>()
    }
    
    public init(coordinator: Coordinator, useCase: SoptletterUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    deinit {
        fetchProfileTask?.cancel()
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()

        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchProfileTask?.cancel()
                owner.fetchProfileTask = Task {
                    do {
                        let result = try await owner.useCase.getSoptletterProfile()
                        output.profileSubject.send(result)
                    } catch is CancellationError {
                        return
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
        
        input.goTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onGoButtonTap?()
                Task {
                    do {
                        try await owner.useCase.completeOnboarding()
                    } catch {
                        owner.showAlert?()
                    }
                }
            }.store(in: cancelBag)
        
        return output
    }
}

