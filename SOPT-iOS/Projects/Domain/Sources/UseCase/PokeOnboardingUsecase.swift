//
//  PokeOnboardingUsecase.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PokeOnboardingUsecase {
  func getRandomAcquaintances(randomUserType: PokeRandomUserType)
  func poke(userId: Int, message: PokeMessageModel, isAnonymous: Bool)
  
  var randomAcquaintances: PassthroughSubject<[PokeRandomUserInfoModel], Never> { get }
  var pokedResponse: PassthroughSubject<PokeUserModel, Never> { get }
  var errorMessage: PassthroughSubject<String?, Never> { get }
}

public final class DefaultPokeOnboardingUsecase {
  private let repository: PokeOnboardingRepositoryInterface
  private let cancelBag = CancelBag()
  
  public let randomAcquaintances = PassthroughSubject<[PokeRandomUserInfoModel], Never>()
  public let pokedResponse = PassthroughSubject<PokeUserModel, Never>()
  public let errorMessage = PassthroughSubject<String?, Never>()
  
  public init(repository: PokeOnboardingRepositoryInterface) {
    self.repository = repository
  }
}

extension DefaultPokeOnboardingUsecase: PokeOnboardingUsecase {
  public func getRandomAcquaintances(randomUserType: PokeRandomUserType) {
    self.repository
      .getRandomAcquaintances(
        randomUserType: randomUserType,
        size: PokeRandomUserQueryCount.onboardingPage
      )
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] value in
          self?.randomAcquaintances.send(value)
        }
      ).store(in: self.cancelBag)
  }
  
  public func poke(userId: Int, message: PokeMessageModel, isAnonymous: Bool) {
    self.repository
      .poke(userId: userId, message: message.content, isAnonymous: isAnonymous)
      .catch { [weak self] error in
        let message = error.toastMessage
        self?.errorMessage.send(message)
        return Empty<PokeUserModel, Never>()
      }
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] value in
          self?.pokedResponse.send(value)
        }
      ).store(in: self.cancelBag)
  }
}
