//
//  PokeMyFriendsListViewModel.swift
//  PokeFeature
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import PokeFeatureInterface

public class PokeMyFriendsListViewModel:
    PokeMyFriendsListViewModelType {
    
    public var onCloseButtonTap: (() -> Void)?
        
    // MARK: - Properties
    
    private let useCase: PokeMyFriendsUseCase
    private var cancelBag = CancelBag()
    
    public let relation: PokeRelation
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let closeButtonTap: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
    }
    
    // MARK: - initialization
    
    public init(relation: PokeRelation, useCase: PokeMyFriendsUseCase) {
        self.relation = relation
        self.useCase = useCase
    }
}
    
extension PokeMyFriendsListViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .sink { _ in
                print("데이터 요청")
            }.store(in: cancelBag)
        
        input.closeButtonTap
            .sink { [weak self] _ in
                self?.onCloseButtonTap?()
            }.store(in: cancelBag)

        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {

    }
}
