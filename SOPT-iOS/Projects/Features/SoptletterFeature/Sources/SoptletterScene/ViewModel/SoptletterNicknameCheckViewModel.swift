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
import SoptletterFeatureInterface

public final class SoptletterNicknameCheckViewModel: SoptletterNicknameCheckViewModelType {
    
    public var onNaviBackTap: (() -> Void)?
    public var onGoButtonTap: (() -> Void)?
    
    private let coordinator: AnyCoordinatorObject
    private var cancelBag = CancelBag()
    
    public struct Input {
        let naviBackTap: Driver<Void>
        let goTap: Driver<Void>
    }
    
    public struct Output { }
    
    public init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.naviBackTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.goTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onGoButtonTap?()
            }.store(in: cancelBag)
        
        return output
    }
}

