//
//  AppJamRankingViewModel.swift
//  StampFeature
//
//  Created by 강윤서 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import StampFeatureInterface

public class AppJamRankingViewModel: AppJamRankingViewModelType {

    // MARK: - Properties

    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let naviBackButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - AppJamCoordinatable
    
    public var onNaviBackTap: (() -> Void)?
}

extension AppJamRankingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .withUnretained(self)
            .sink { owner, _ in
                // TODO: API 호출
            }.store(in: cancelBag)
        
        input.naviBackButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                // TODO: VC에서 바인딩 필요
                #warning("TODO: VC에서 바인딩 필요")
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        return output
    }
}
