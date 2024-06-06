//
//  PokeMyFriendsViewModel.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import PokeFeatureInterface
import BaseFeatureDependency

public class PokeMyFriendsViewModel:
    PokeMyFriendsViewModelType {
    
    public var showFriendsListButtonTap: ((PokeRelation) -> Void)?
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)?
    public var onProfileImageTapped: ((Int) -> Void)?
    public var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)?

    // MARK: - Properties
    
    private let useCase: PokeMyFriendsUseCase
    private var cancelBag = CancelBag()
    private var myFriends: PokeMyFriendsModel?
    private let eventTracker = PokeEventTracker()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let moreFriendListButtonTap: Driver<PokeRelation>
        let pokeButtonTap: Driver<PokeUserModel?>
        let profileImageTap: Driver<PokeUserModel?>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let myFriends = PassthroughSubject<PokeMyFriendsModel, Never>()
    }
    
    // MARK: - initialization
    
    public init(useCase: PokeMyFriendsUseCase) {
        self.useCase = useCase
    }
}
    
extension PokeMyFriendsViewModel {
    public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.eventTracker.trackViewEvent(with: .viewPokeFriend)
                owner.useCase.getFriends()
            }.store(in: cancelBag)
        
        input.moreFriendListButtonTap
            .withUnretained(self)
            .sink { owner, relation in
                owner.showFriendsListButtonTap?(relation)
            }.store(in: cancelBag)
        
        input.pokeButtonTap
            .compactMap { $0 }
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                return value
            }
            .sink {[weak self] userModel, messageModel, isAnonymous in
                self?.eventTracker.trackClickPokeEvent(clickView: .friend, playgroundId: userModel.playgroundId)
                self?.useCase.poke(userId: userModel.userId, message: messageModel, isAnonymous: isAnonymous)
            }.store(in: cancelBag)
        
        input.profileImageTap
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.eventTracker.trackClickMemberProfileEvent(clickView: .friend, playgroundId: user.playgroundId)
                self?.onProfileImageTapped?(user.playgroundId)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.myFriends
            .subscribe(output.myFriends)
            .store(in: cancelBag)
        
        useCase.myFriends
            .sink { [weak self] myFriends in
                self?.myFriends = myFriends
            }.store(in: cancelBag)
        
        useCase.pokedResponse
            .withUnretained(self)
            .sink { owner, user in
              owner.myFriends = owner.myFriends?.replaceUser(newUserModel: user)
              if let myFriends = owner.myFriends {
                output.myFriends.send(myFriends)
              }
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
