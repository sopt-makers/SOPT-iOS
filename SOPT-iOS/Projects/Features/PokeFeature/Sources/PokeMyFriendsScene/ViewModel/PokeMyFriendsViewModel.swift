//
//  PokeMyFriendsViewModel.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import PokeFeatureInterface

public class PokeMyFriendsViewModel:
    PokeMyFriendsViewModelType {
    
    public var showFriendsListButtonTap: ((PokeRelation) -> Void)?
        
    // MARK: - Properties
    
    private let useCase: PokeMyFriendsUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let moreFriendListButtonTap: Driver<PokeRelation>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let myFriends = PassthroughSubject<PokeMyFriendsModel, Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: PokeMyFriendsUseCase) {
        self.useCase = useCase
    }
}
    
extension PokeMyFriendsViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getFriends()
            }.store(in: cancelBag)
        
        input.moreFriendListButtonTap
            .withUnretained(self)
            .sink { owner, relation in
                owner.showFriendsListButtonTap?(relation)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.myFriends
            .subscribe(output.myFriends)
            .store(in: cancelBag)
    }
}
