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
    var friendRandomUsers: PassthroughSubject<PokeFriendRandomUserModel, Never> { get }
    var pokedResponse: PassthroughSubject<PokeUserModel, Never> { get }
    var madeNewFriend: PassthroughSubject<PokeUserModel, Never> { get }
    var errorMessage: PassthroughSubject<String?, Never> { get }
    var errorOccured: PassthroughSubject<Void, Never> { get }
    var isNewUser: PassthroughSubject<Bool, Never> { get }
    
    func getWhoPokedToMe()
    func getFriend()
    func getFriendRandomUser(randomType: PokeRandomUserType, size: Int)
    func poke(userId: Int, message: PokeMessageModel, isAnonymous: Bool, willBeNewFriend: Bool)
    func checkPokeOnboardingNeeded()
}

public class DefaultPokeMainUseCase {
    public let repository: PokeMainRepositoryInterface
    public let cancelBag = CancelBag()
    
    public let pokedToMeUser = PassthroughSubject<PokeUserModel?, Never>()
    public let myFriend = PassthroughSubject<[PokeUserModel], Never>()
    public let friendRandomUsers = PassthroughSubject<PokeFriendRandomUserModel, Never>()
    public let pokedResponse = PassthroughSubject<PokeUserModel, Never>()
    public let madeNewFriend = PassthroughSubject<PokeUserModel, Never>()
    public let errorMessage = PassthroughSubject<String?, Never>()
    public let errorOccured = PassthroughSubject<Void, Never>()
    public let isNewUser = PassthroughSubject<Bool, Never>()
    
    public init(repository: PokeMainRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeMainUseCase: PokeMainUseCase {
    
    public func getWhoPokedToMe() {
        repository.getWhoPokeToMe()
            .catch { [weak self] error -> Just<PokeUserModel?> in
                self?.errorOccured.send()
                return Just(nil)
            }
            .withUnretained(self)
            .sink { event in
                print("GetPokedToMe State: \(event)")
            } receiveValue: { owner, pokeUser in
                owner.pokedToMeUser.send(pokeUser)
            }.store(in: cancelBag)
    }
    
    public func getFriend() {
        repository.getFriend()
            .catch { [weak self] error -> Just<[PokeUserModel]> in
                self?.errorOccured.send()
                return Just([])
            }
            .withUnretained(self)
            .sink { event in
                print("GetFriend State: \(event)")
            } receiveValue: { owner, friend in
                owner.myFriend.send(friend)
            }.store(in: cancelBag)
    }
    
    public func getFriendRandomUser(randomType: PokeRandomUserType, size: Int) {
        repository.getFriendRandomUser(randomType: randomType.rawValue, size: size)
            .catch { [weak self] error -> Just<PokeFriendRandomUserModel> in
                
                self?.errorOccured.send()
                return Just(PokeFriendRandomUserModel(randomInfoList: []))
            }
            .withUnretained(self)
            .sink { event in
                print("GetFriendRandomUser State: \(event)")
            } receiveValue: { owner, randomUsers in
                owner.friendRandomUsers.send(randomUsers)
            }.store(in: cancelBag)
    }
    
    public func poke(userId: Int, message: PokeMessageModel, isAnonymous: Bool, willBeNewFriend: Bool) {
        self.repository
            .poke(userId: userId, message: message.content, isAnonymous: isAnonymous)
            .catch { [weak self] error in
                let message = error.toastMessage
                self?.errorMessage.send(message)
                return Empty<PokeUserModel, Never>()
            }.sink { [weak self] user in
                self?.pokedResponse.send(user)
                if willBeNewFriend {
                    self?.madeNewFriend.send(user)
                }
            }.store(in: self.cancelBag)
    }
    
    public func checkPokeOnboardingNeeded() {
    #warning("TODO: 온보딩 노출조건 변경으로 기존 유저들을 위해서 임시로 추가 추후 getIsNewUser 체크 로직 제거 필요")
        Just(UserDefaultKeyList.User.isVisitedPokeMainView ?? false)
            .withUnretained(self)
            .flatMap { [weak self] owner, isVisited in
                if isVisited {
                    return Just(false)
                        .eraseToAnyPublisher()
                } else {
                    return owner.repository.getIsNewUser()
                        .replaceError(with: false)
                        .eraseToAnyPublisher()
                }
            }
            .withUnretained(self)
            .sink { [weak self] owner, isNewUser in
                owner.isNewUser.send(isNewUser)
            }.store(in: self.cancelBag)
    }
}
