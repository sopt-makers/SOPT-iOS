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
    var friends = [PokeUserModel]()
    
    private var isPaging = false
    private var page = 0
    
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let closeButtonTap: Driver<Void>
        let reachToBottom: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let friendCount = PassthroughSubject<Int, Never>()
        let needToReloadFriendList = PassthroughSubject<Void, Never>()
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
            .merge(with: input.reachToBottom)
            .withUnretained(self)
            .filter { owner, _ in
                owner.isPaging == false
            }
            .sink { owner, _ in
                owner.isPaging = true
                owner.useCase.getFriends(relation: owner.relation.queryValueName, page: owner.page)
                owner.page += 1
            }.store(in: cancelBag)
        
        input.closeButtonTap
            .sink { [weak self] _ in
                self?.onCloseButtonTap?()
            }.store(in: cancelBag)

        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.myFriendsList
            .withUnretained(self)
            .sink { owner, model in
                owner.friends.append(contentsOf: model.friendList)
                output.friendCount.send(model.totalSize)
                output.needToReloadFriendList.send()
                owner.isPaging = false
            }.store(in: cancelBag)
    }
}
