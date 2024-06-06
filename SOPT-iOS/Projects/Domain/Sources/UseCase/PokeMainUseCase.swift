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
  var isPokeNewUser: PassthroughSubject<Bool, Never> { get set }

  func getWhoPokedToMe()
  func getFriend()
  func getFriendRandomUser(randomType: PokeRandomUserType, size: Int)
  func poke(userId: Int, message: PokeMessageModel, isAnonymous: Bool, willBeNewFriend: Bool)
  func checkPokeNewUser()
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
  public var isPokeNewUser = PassthroughSubject<Bool, Never>()

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

  public func getFriendRandomUser(randomType: PokeRandomUserType, size: Int) {
    repository.getFriendRandomUser(randomType: randomType.rawValue, size: size)
      .sink { event in
        print("GetFriendRandomUser State: \(event)")
      } receiveValue: { [weak self] randomUsers in
        self?.friendRandomUsers.send(randomUsers)
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

  public func checkPokeNewUser() {
    repository.checkPokeNewUser()
      .catch { error in
        print("CheckPokeNewUser State: \(error)")
        return Just(false)
      }.sink { [weak self] isNewUser in
        self?.isPokeNewUser.send(isNewUser)
      }.store(in: cancelBag)
  }
}
