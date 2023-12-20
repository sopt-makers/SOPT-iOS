//
//  PokeMainUseCase.swift
//  Domain
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PokeMainUseCase {
    var pokedToMeUser: PassthroughSubject<PokeUserModel?, Never> { get }
    var myFriend: PassthroughSubject<[PokeUserModel], Never> { get }
    var friendRandomUsers: PassthroughSubject<[PokeFriendRandomUserModel], Never> { get }
    
    func getWhoPokedToMe()
    func getFriend()
    func getFriendRandomUser()
}

public class DefaultPokeMainUseCase {
    public let repository: PokeMainRepositoryInterface
    public let cancelBag = CancelBag()
    
    public let pokedToMeUser = PassthroughSubject<PokeUserModel?, Never>()
    public let myFriend = PassthroughSubject<[PokeUserModel], Never>()
    public let friendRandomUsers = PassthroughSubject<[PokeFriendRandomUserModel], Never>()


    public init(repository: PokeMainRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeMainUseCase: PokeMainUseCase {
    public func getWhoPokedToMe() {
        repository.getWhoPokeToMe()
            .catch { _ in
                Just<PokeUserModel?>(nil)
            }
            .sink { event in
                print("GetPokedToMe State: \(event)")
            } receiveValue: { [weak self] pokeUser in
                self?.pokedToMeUser.send(pokeUser)
            }.store(in: cancelBag)
    }
    
    public func getFriend() {
        repository.getFriend()
            .sink { event in
                print("GetFriend State: \(event)")
            } receiveValue: { [weak self] friend in
                self?.myFriend.send(friend)
            }.store(in: cancelBag)
    }
    
    public func getFriendRandomUser() {
        repository.getFriendRandomUser()
            .sink { event in
                print("GetFriendRandomUser State: \(event)")
            } receiveValue: { [weak self] randomUsers in
                self?.friendRandomUsers.send(randomUsers)
            }.store(in: cancelBag)
    }
}
