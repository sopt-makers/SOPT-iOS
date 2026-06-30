//
//  SoptletterMainViewModel.swift
//  SoptletterFeature
//
//  Created by dev on 6/30/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import BaseFeatureDependency
import SoptletterFeatureInterface

public final class SoptletterMainViewModel: SoptletterMainViewModelType {
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {}
    
    private var cancelBag = CancelBag()
    
    public var onNaviBackTap: (() -> Void)?
    public var onWriteTap: (() -> Void)?
    public var onPostItTap: (() -> Void)?
    public var onDownloadTap: (() -> Void)?
    public var onReportTap: (() -> Void)?        
    
}

extension SoptletterMainViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        // TODO: 솝레터 리스트 API 요청
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner in 
                print("SoptletterMainViewModel View Did Load")
            }.store(in: cancelBag)
        return output
    }
}
