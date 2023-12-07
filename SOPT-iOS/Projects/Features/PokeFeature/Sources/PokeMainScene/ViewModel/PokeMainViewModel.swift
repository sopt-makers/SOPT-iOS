//
//  PokeMainViewModel.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import PokeFeatureInterface

public class PokeMainViewModel:
    PokeMainViewModelType {
    
    public var onNaviBackTap: (() -> Void)?
    
    // MARK: - Properties
    
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let naviBackButtonTap: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
    }
    
    // MARK: - initialization
    
    public init() {
        
    }
}
    
extension PokeMainViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.naviBackButtonTap
            .sink { [weak self] _ in
                self?.onNaviBackTap?()
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    }
}
