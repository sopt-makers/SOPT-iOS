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
    func poke(userId: Int, message: PokeMessageModel)
    
    var pokedMeList: PassthroughSubject<[PokeUserModel], Never> { get }
    var pokedResponse: PassthroughSubject<PokeUserModel, Never> { get }
}

public final class DefaultPokeNotificationUsecase {
    private let repository: PokeNotificationRepositoryInterface
    private let cancelBag = CancelBag()
    private var pageIndex: Int = 0
    private var reachedToPageLimit = false

    // MARK: UsecaseProtocol
    public let pokedMeList = PassthroughSubject<[PokeUserModel], Never>()
    public let pokedResponse = PassthroughSubject<PokeUserModel, Never>()

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
    
    public func poke(userId: Int, message: PokeMessageModel) {
        self.repository
            .poke(userId: userId, message: message.content)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] value in
                    self?.pokedResponse.send(value)
                }
            ).store(in: self.cancelBag)
    }
}
