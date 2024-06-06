//
//  PokeNotificationUsecase.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol PokeNotificationUsecase {
    func getWhoPokedMeList()
    func poke(user: PokeUserModel, message: PokeMessageModel, isAnonymous: Bool)
    
    var pokedMeList: PassthroughSubject<[PokeUserModel], Never> { get }
    var pokedResponse: PassthroughSubject<(response: PokeUserModel, isNewlyAddedFriend: Bool), Never> { get }
    var errorMessage: PassthroughSubject<String?, Never> { get }
}

public final class DefaultPokeNotificationUsecase {
    private let repository: PokeNotificationRepositoryInterface
    private let cancelBag = CancelBag()
    private var pageIndex: Int = 0
    private var reachedToPageLimit = false

    // MARK: UsecaseProtocol
    public let pokedMeList = PassthroughSubject<[PokeUserModel], Never>()
    public let pokedResponse = PassthroughSubject<(response: PokeUserModel, isNewlyAddedFriend: Bool), Never>()
    public let errorMessage = PassthroughSubject<String?, Never>()

    public init(repository: PokeNotificationRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeNotificationUsecase: PokeNotificationUsecase {
    public func getWhoPokedMeList() {
        guard !self.reachedToPageLimit else { return }
        
        self.repository
            .getWhoPokedMeList(page: self.pageIndex)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] userModels, pageIndex in
                    // TBD: paging endindex를 주세요
                    
                    self?.pageIndex = pageIndex + 1
                    self?.pokedMeList.send(userModels)
                }).store(in: self.cancelBag)
    }
    
    public func poke(user: PokeUserModel, message: PokeMessageModel, isAnonymous: Bool) {
        self.repository
            .poke(userId: user.userId, message: message.content, isAnonymous: isAnonymous)
            .catch { [weak self] error in
                let message = error.toastMessage
                self?.errorMessage.send(message)
                return Empty<PokeUserModel, Never>()
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] userModel in
                    let verifyIsNewlyAddedFriend = {
                        guard user.isFirstMeet else { return false }
                        
                        return user.isFirstMeet && userModel.isFirstMeet == false
                    }
                    
                    self?.pokedResponse.send((response: userModel, isNewlyAddedFriend: verifyIsNewlyAddedFriend()))
                }
            ).store(in: self.cancelBag)
    }
}
