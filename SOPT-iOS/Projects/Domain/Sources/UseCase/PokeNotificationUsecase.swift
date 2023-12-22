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
    
    var pokedMeList: PassthroughSubject<[PokeUserModel], Never> { get }
}

public final class DefaultPokeNotificationUsecase {
    private let repository: PokeNotificationRepositoryInterface
    private let cancelBag = CancelBag()
    private var pageIndex: Int = 0

    // MARK: UsecaseProtocol
    public let pokedMeList = PassthroughSubject<[PokeUserModel], Never>()

    public init(repository: PokeNotificationRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultPokeNotificationUsecase: PokeNotificationUsecase {
    public func getWhoPokedMeList() {
        self.repository
            .getWhoPokedMeList(page: self.pageIndex)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] userModels, pageIndex in
                    self?.pageIndex = pageIndex + 1
                    self?.pokedMeList.send(userModels)
                }).store(in: self.cancelBag)
    }
}
