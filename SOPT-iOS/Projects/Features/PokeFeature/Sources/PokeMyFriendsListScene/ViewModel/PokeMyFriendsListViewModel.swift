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
        
    // MARK: - Properties
    
//    private let useCase: PokeMyFriendsListUseCase
    private var cancelBag = CancelBag()
    
    public let relation: PokeRelation
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
    }
    
    // MARK: - initialization
    
    public init(relation: PokeRelation) {
        self.relation = relation
    }
}
    
extension PokeMyFriendsListViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)

        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {

    }
}
