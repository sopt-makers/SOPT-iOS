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
        fetchProfileTask = nil
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        bindOutput(output: output)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchProfile()
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
                owner.completeOnboarding()
            }.store(in: cancelBag)
        
        return output
    }
}

private extension SoptletterNicknameCheckViewModel {
    func fetchProfile() {
        fetchProfileTask?.cancel()
        fetchProfileTask = Task {
            do {
                try await useCase.getSoptletterProfile()
            } catch {
                // TODO: 에러처리
            }
        }
        fetchProfileTask = nil
    }
    
    func completeOnboarding() {
        Task {
            do {
                try await useCase.completeOnboarding()
            } catch {
                // TODO: 에러처리
            }
        }
    }
    
    func bindOutput(output: Output) {
        useCase.profileResult.asDriver()
            .withUnretained(self)
            .sink { owner, profile in
                output.profileSubject.send(profile)
            }.store(in: cancelBag)
    }
}

