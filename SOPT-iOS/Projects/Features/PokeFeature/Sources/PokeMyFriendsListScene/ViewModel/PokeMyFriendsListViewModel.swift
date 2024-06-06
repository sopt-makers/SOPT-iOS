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
import BaseFeatureDependency

public class PokeMyFriendsListViewModel:
    PokeMyFriendsListViewModelType {
    
    public var onCloseButtonTap: (() -> Void)?
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)?
    public var onProfileImageTapped: ((Int) -> Void)?
    public var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)?

    // MARK: - Properties
    
    private let useCase: PokeMyFriendsUseCase
    private var cancelBag = CancelBag()
    private let eventTracker = PokeEventTracker()
    
    public let relation: PokeRelation
    var friends = [PokeUserModel]()
    
    private var isPaging = false
    private var page = 0
    
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let closeButtonTap: Driver<Void>
        let reachToBottom: Driver<Void>
        let pokeButtonTap: Driver<PokeUserModel?>
        let profileImageTap: Driver<PokeUserModel?>
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
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.eventTracker.trackViewFriendsListEvent(friendType: self.relation)
            }.store(in: cancelBag)
        
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
        
        input.pokeButtonTap
            .compactMap { $0 }
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                
                return value
            }
            .sink {[weak self] userModel, messageModel, isAnonymous in
                self?.useCase.poke(userId: userModel.userId, message: messageModel, isAnonymous: isAnonymous)
            }.store(in: cancelBag)
        
        input.profileImageTap
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.onProfileImageTapped?(user.playgroundId)
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
        
        useCase.pokedResponse
            .withUnretained(self)
            .sink { owner, user in
                if let index = owner.friends.firstIndex(where: { $0.userId == user.userId }) {
                    owner.friends[index] = user
                }
                
                output.needToReloadFriendList.send()
                if user.isAnonymous {
                  if user.pokeNum == 5 || user.pokeNum == 11 {
                    owner.onAnonymousFriendUpgrade?(user)
                  }
                }
            }.store(in: cancelBag)
        
        useCase.pokedResponse
            .sink { user in
                ToastUtils.showMDSToast(type: .success, text: I18N.Poke.pokeSuccess)
                let notiName = NotiList.makeNotiName(list: .pokedResponse)
                NotificationCenter.default.post(name: notiName, object: user)
            }.store(in: cancelBag)
        
        useCase.errorMessage
            .compactMap { $0 }
            .sink { message in
                ToastUtils.showMDSToast(type: .alert, text: message)
            }.store(in: cancelBag)
    }
}
