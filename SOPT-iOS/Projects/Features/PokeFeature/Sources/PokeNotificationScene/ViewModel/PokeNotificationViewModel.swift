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
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)?
    public var onNewFriendAdded: ((_ friendName: String) -> Void)?
    public var onAnonymousFriendUpgrade: ((PokeUserModel) -> Void)?

    private let usecase: PokeNotificationUsecase
    private let cancelBag = CancelBag()
    private let eventTracker = PokeEventTracker()
    
    init(usecase: PokeNotificationUsecase) {
        self.usecase = usecase
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

                if isNewFriend {
                  self?.onNewFriendAdded?(userModel.name)
                  return
                }
                if userModel.isAnonymous {
                  if userModel.pokeNum == 5 || userModel.pokeNum == 11 {
                    self?.onAnonymousFriendUpgrade?(userModel)
                  }
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
