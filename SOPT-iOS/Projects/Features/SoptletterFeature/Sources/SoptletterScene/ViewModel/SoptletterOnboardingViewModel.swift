//
//  SoptletterOnboardingViewModel.swift
//  SoptletterFeature
//
//  Created by 최주리 on 6/30/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import BaseFeatureDependency
import SoptletterFeatureInterface

public final class SoptletterOnboardingViewModel: SoptletterOnboardingViewModelType {
    
    public var onNaviBackTap: (() -> Void)?
    public var onStartButtonTap: (() -> Void)?
    
    private let coordinator: AnyCoordinatorObject
    private let useCase: SoptletterUseCase
    
    private var cancelBag = CancelBag()
    
    public struct Input {
        let naviBackTap: Driver<Void>
        let startTap: Driver<Void>
    }
    
    public struct Output { }
    
    public init(coordinator: Coordinator, useCase: SoptletterUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.startTap
            .withUnretained(self)
            .sink { owner, _ in
                Task {
                    do {
                        _ = try await owner.useCase.getSoptletterProfile()
                        try await owner.useCase.completeOnboarding()
                        
                        await MainActor.run {
                            owner.onStartButtonTap?()
                        }
                    } catch {
                        // TODO: 에러처리
                    }
                }
            }.store(in: cancelBag)
        
        return output
    }
}

