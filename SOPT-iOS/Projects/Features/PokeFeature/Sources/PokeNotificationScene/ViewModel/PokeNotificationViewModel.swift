//
//  PokeNotificationViewModel.swift
//  PokeFeature
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeNotificationViewModel: PokeNotificationViewModelType {
    
    // MARK: - Trigger
    
    public var onNaviBackTapped: (() -> Void)?
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)?
    public var onNewFriendAdded: ((_ friendName: String) -> Void)?
    public var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)?
    public var onProfileImageTapped: ((Int) -> Void)?
    
    // MARK: - Properties
    
    private let coordinator: AnyCoordinatorObject
    private let usecase: PokeNotificationUsecase
    private let cancelBag = CancelBag()
    private let eventTracker = PokeEventTracker()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoaded: Driver<Void>
        let reachToBottom: Driver<Void>
        let pokedAction: Driver<PokeUserModel>
        let profileButtonTap: Driver<PokeUserModel>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let pokeToMeHistoryList = PassthroughSubject<[PokeUserModel], Never>()
        let pokedResult = PassthroughSubject<PokeUserModel, Never>()
    }
    
    init(usecase: PokeNotificationUsecase, coordinator: Coordinator) {
        self.usecase = usecase
        self.coordinator = coordinator
    }
}

extension PokeNotificationViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoaded
            .sink { [weak self] _ in
                self?.eventTracker.trackViewEvent(with: .viewPokeAlarmDetail)
            }.store(in: cancelBag)
        
        input.viewDidLoaded
            .merge(with: input.reachToBottom)
            .sink(receiveValue: { [weak self] _ in
                self?.usecase.getWhoPokedMeList()
            }).store(in: self.cancelBag)
        
        input.pokedAction
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                
                return value
            }
            .sink(receiveValue: { [weak self] userModel, messageModel, isAnonymous in
                self?.eventTracker.trackClickPokeEvent(clickView: .pokeAlarm)
                self?.usecase.poke(user: userModel, message: messageModel, isAnonymous: isAnonymous)
                let messageType = userModel.pokeRelation == .nonFriend ? "poke_someone" : "poke_friend"
                self?.eventTracker.trackSendMessageEvent(isAnonymous: isAnonymous, messageType: messageType, message: messageModel)
            }).store(in: cancelBag)
        
        input.profileButtonTap
          .sink { [weak self] user in
            self?.onProfileImageTapped?(user.userId)
          }.store(in: cancelBag)

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

                if isNewFriend {
                  let name = userModel.isAnonymous ? userModel.anonymousName : userModel.name
                  self?.onNewFriendAdded?(name)
                  return
                }

                let isUpgrade = (userModel.pokeNum == 11 || userModel.pokeNum == 12) ||
                                (userModel.isAnonymous && (userModel.pokeNum == 5 || userModel.pokeNum == 6))
                
                if isUpgrade {
                    self?.onAnonymousFriendUpgrade?(userModel)
                }
            }).store(in: cancelBag)
        
        self.usecase
            .pokedResponse
            .sink { user in
                ToastUtils.showMDSToast(type: .success, text: I18N.Poke.pokeSuccess)
                let notiName = NotiList.makeNotiName(list: .pokedResponse)
                NotificationCenter.default.post(name: notiName, object: user.response)
            }.store(in: cancelBag)

        self.usecase
            .errorMessage
            .compactMap { $0 }
            .sink { message in
                ToastUtils.showMDSToast(type: .alert, text: message)
            }.store(in: cancelBag)
    }
}
