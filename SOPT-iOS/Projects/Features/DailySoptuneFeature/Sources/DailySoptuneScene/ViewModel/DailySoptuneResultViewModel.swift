//
//  DailySoptuneResultViewModel.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import DailySoptuneFeatureInterface
import BaseFeatureDependency

public final class DailySoptuneResultViewModel: DailySoptuneResultViewModelType {
    
    public var onNaviBackButtonTapped: (() -> Void)?
    public var onReceiveTodaysFortuneCardTap: ((DailySoptuneCardModel) -> Void)?
    public var onKokButtonTapped: ((Domain.PokeUserModel) -> Core.Driver<(Domain.PokeUserModel, Domain.PokeMessageModel, isAnonymous: Bool)>)?
    public var onReceiveTodaysFortuneCardButtonTapped: ((Domain.DailySoptuneCardModel) -> Void)?
    public var onProfileImageTapped: ((Int) -> Void)?
    
    // MARK: - Properties

    private let useCase: DailySoptuneUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let receiveTodaysFortuneCardTap: Driver<Void>
        let kokButtonTap: Driver<PokeUserModel?>
        let profileImageTap: Driver<PokeUserModel?>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let randomUser = PassthroughSubject<PokeRandomUserInfoModel, Never>()
        let messageTemplates = PassthroughSubject<PokeMessagesModel, Never>()
        let pokeResponse = PassthroughSubject<PokeUserModel, Never>()
    }
    
    // MARK: - Initialization
    
    public init(useCase: DailySoptuneUseCase) {
        self.useCase = useCase
    }
}

extension DailySoptuneResultViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getRandomUser()
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTapped?()
                AmplitudeInstance.shared.track(eventType: .clickLeaveSoptuneResult)
            }.store(in: cancelBag)
        
        input.receiveTodaysFortuneCardTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.getTodaysFortuneCard()
                AmplitudeInstance.shared.track(eventType: .clickGetSoptuneCard)
            }.store(in: cancelBag)
        
        input.kokButtonTap
            .compactMap { $0 }
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)> in
                guard let self, let value = self.onKokButtonTapped?(userModel) else { return .empty() }
                AmplitudeInstance.shared.track(eventType: .clickSoptuneRamdomPeople)
                return value
            }
            .sink { [weak self] userModel, messageModel, isAnonymous in
                AmplitudeInstance.shared.track(eventType: .sendChoice, eventProperties: ["index": messageModel.messageId, "message": messageModel.content, "isAnonymous": isAnonymous])
                self?.useCase.poke(userId: userModel.userId, message: messageModel, isAnonymous: isAnonymous)
            }.store(in: cancelBag)
        
        input.profileImageTap
            .compactMap { $0 }
            .withUnretained(self)
            .sink { owner, user in
                owner.onProfileImageTapped?(user.playgroundId)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.todaysFortuneCard
            .withUnretained(self)
            .sink { owner, cardModel in
                owner.onReceiveTodaysFortuneCardButtonTapped?(cardModel)
            }
            .store(in: cancelBag)
        
        useCase.randomUser
            .asDriver()
            .withUnretained(self)
            .sink { owner, values in
                guard !values.isEmpty else { return }
                output.randomUser.send(values[0])
            }.store(in: cancelBag)

        useCase.pokedResponse
            .sink { _ in
                ToastUtils.showMDSToast(type: .success, text: I18N.Poke.pokeSuccess)
            }
            .store(in: cancelBag)
    }
}
