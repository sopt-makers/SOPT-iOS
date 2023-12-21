//
//  PokeMyFriendsUseCase.swift
//  Domain
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PokeMyFriendsUseCase {
    var myFriends: PassthroughSubject<PokeMyFriendsModel, Never> { get }
    func getFriends()
}

public class DefaultPokeMyFriendsUseCase {
    public let repository: PokeMyFriendsRepositoryInterface
    public let cancelBag = CancelBag()

    public let myFriends = PassthroughSubject<PokeMyFriendsModel, Never>()

    public init(repository: PokeMyFriendsRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeMyFriendsUseCase: PokeMyFriendsUseCase {
    public func getFriends() {
        repository.getFriends()
            .sink { event in
                print("GetFriendsList State: \(event)")
            } receiveValue: { [weak self] friends in
                self?.myFriends.send(friends)
            }.store(in: cancelBag)
    }
}
