//
//  SoptletterPrintViewModel.swift
//  SoptletterFeature
//
//  Created by dev on 7/12/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import BaseFeatureDependency
import SoptletterFeatureInterface
import Domain

final public class SoptletterPrintViewModel: SoptletterPrintViewModelType {
    
    public var onNaviBackTap: (() -> Void)?
    public var onPDFSaveTap: ((URL) -> Void)?
    
    // MARK: - Input & Output
    
    public struct Input {
        let pdfSaveButtonTap: Driver<Void>
        let naviBackButtonTap: Driver<Void>
    }
    public struct Output {}
    
    // MARK: - Properties
    
    private let coordinator: AnyCoordinatorObject
    private let pdfURL: URL
    
    public init(coordinator: Coordinator, pdfURL: URL) {
        self.coordinator = coordinator
        self.pdfURL = pdfURL
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input
            .pdfSaveButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onPDFSaveTap?(owner.pdfURL)                
            }.store(in: cancelBag)
        
        input
            .naviBackButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        return output
    }
}
