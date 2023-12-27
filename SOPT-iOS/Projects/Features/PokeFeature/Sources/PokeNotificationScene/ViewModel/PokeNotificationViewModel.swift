//
//  PokeNotificationViewModel.swift
//  PokeFeature
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeNotificationViewModel: PokeNotificationViewModelType {
    public struct Input {
        let viewDidLoaded: Driver<Void>
        let reachToBottom: Driver<Void>
        let pokedAction: Driver<PokeUserModel>
    }
    
    public struct Output {
        let pokeToMeHistoryList = PassthroughSubject<[PokeUserModel], Never>()
        let pokedResult = PassthroughSubject<PokeUserModel, Never>()
    }
    
    public var onNaviBackTapped: (() -> Void)?
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel)>)?
    public var onNewFriendAdded: ((_ friendName: String) -> Void)?

    private let usecase: PokeNotificationUsecase
    private let cancelBag = CancelBag()
    
    init(usecase: PokeNotificationUsecase) {
        self.usecase = usecase
    }
}

extension PokeNotificationViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoaded
            .merge(with: input.reachToBottom)
            .sink(receiveValue: { [weak self] _ in
                self?.usecase.getWhoPokedMeList()
            }).store(in: self.cancelBag)
        
        input.pokedAction
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                
                return value
            }
            .sink(receiveValue: { [weak self] userModel, messageModel in
                self?.usecase.poke(user: userModel, message: messageModel)
            }).store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.usecase
            .pokedMeList
            .asDriver()
            .sink(receiveValue: { values in
                output.pokeToMeHistoryList.send(values)
            }).store(in: cancelBag)
        
        self.usecase
            .pokedResponse
            .asDriver()
            .sink(receiveValue: { [weak self] userModel, isNewFriend in
                output.pokedResult.send(userModel)
                
                guard isNewFriend else { return }
                
                self?.onNewFriendAdded?(userModel.name)
            }).store(in: cancelBag)
    }
}
