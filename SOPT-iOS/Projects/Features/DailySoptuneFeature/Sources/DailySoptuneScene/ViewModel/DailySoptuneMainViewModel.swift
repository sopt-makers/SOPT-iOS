//
//  DailySoptuneMainViewModel.swift
//  DailySoptuneFeatureInterface
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import BaseFeatureDependency
import Domain

import DailySoptuneFeatureInterface

public final class DailySoptuneMainViewModel: DailySoptuneMainViewModelType {
    
    // MARK: - Trigger
    
    public var onNaviBackTap: (() -> Void)?
    public var onReciveTodayFortuneButtonTap: ((DailySoptuneResultModel) -> Void)?
    
	// MARK: - Properties

    private let useCase: DailySoptuneUseCase
    private let coordinator: AnyCoordinatorObject
	private var cancelBag = CancelBag()
	
	// MARK: - Inputs
	
	public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let receiveTodayFortuneButtonTap: Driver<Void>
	}
	
	// MARK: - Outputs
	
	public struct Output { }
	
	// MARK: - Initialization
	
    public init(useCase: DailySoptuneUseCase, coordinator: AnyCoordinatorObject) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension DailySoptuneMainViewModel {
	public func transform(from input: Input, cancelBag: CancelBag) -> Output {
		let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                AmplitudeInstance.shared.track(eventType: .viewSoptuneMain)
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
                AmplitudeInstance.shared.track(eventType: .clickLeaveSoptuneMain)
            }.store(in: cancelBag)
        
        input.receiveTodayFortuneButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getDailySoptuneResult(date: DateFormatManager.shared.transformDateFormat(to: .dateWithDash))
                AmplitudeInstance.shared.track(eventType: .clickCheckTodaySoptune)
            }.store(in: cancelBag)
        
		return output
	}
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.dailySoptuneResult
            .withUnretained(self)
            .sink { owner, resultModel in
                owner.onReciveTodayFortuneButtonTap?(resultModel)
            }
            .store(in: cancelBag)
    }
}
