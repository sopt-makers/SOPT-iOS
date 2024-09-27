//
//  DailySoptuneMainViewModel.swift
//  DailySoptuneFeatureInterface
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

public class DailySoptuneMainViewModel: DailySoptuneMainViewModelType {
	
	// MARK: - Properties

	private var cancelBag = CancelBag()
	
	// MARK: - Inputs
	
	public struct Input {
	}
	
	// MARK: - Outputs
	
	public struct Output {
	}
	
	// MARK: - Initialization
	
	public init() {
		
	}
}

extension DailySoptuneMainViewModel {
	public func transform(from input: Input, cancelBag: CancelBag) -> Output {
		let output = Output()
		return output
	}
}
