//
//  PokeOnboardingViewModel.swift
//  PokeFeatureInterface
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeOnboardingViewModel: PokeOnboardingViewModelType {
    public struct Input {
        let viewDidLoaded: Driver<Void>
        let pullToRefreshTriggered: Driver<Void>
        let pokeButtonTapped: Driver<PokeUserModel>
        let avatarTapped: Driver<PokeUserModel>
        let messageCommandClicked: Driver<PokeMessageModel>
    }
    
    public struct Output {
        let randomAcquaintance = PassthroughSubject<[PokeUserModel], Never>()
        let pokedResult = PassthroughSubject<PokeUserModel, Never>()
    }
    
    public var onNaviBackTapped: (() -> Void)?
    public var onFirstVisitInOnboarding: (() -> Void)?
    public var onAvartarTapped: ((_ playgroundId: String) -> Void)?
    public var onPokeButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel)>)?
    public var onMyFriendsTapped: (() -> Void)?
    
    // MARK: Privates
    private let usecase: PokeOnboardingUsecase
    
    // MARK: - Lifecycles
    public init(usecase: PokeOnboardingUsecase) {
        self.usecase = usecase
    }
}

extension PokeOnboardingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoaded
            .withUnretained(self)
            .sink(receiveValue: { [weak self] _ in
                self?.usecase.getRandomAcquaintances()
            }).store(in: cancelBag)
        
        input.viewDidLoaded
            .map { _ in UserDefaultKeyList.User.isFirstVisitToPokeOnboardingView ?? true }
            .sink(receiveValue: { [weak self] isFirstVisit in
                guard isFirstVisit else { return }
                UserDefaultKeyList.User.isFirstVisitToPokeOnboardingView = false
                self?.onFirstVisitInOnboarding?()
            }).store(in: cancelBag)
        
        input.pokeButtonTapped
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel)> in
                guard let self, let value = self.onPokeButtonTapped?(userModel) else { return .empty() }
                
                return value
            }
            .sink(receiveValue: { [weak self] userModel, messageModel in
                self?.usecase.poke(userId: userModel.userId, message: messageModel)
            }).store(in: cancelBag)
        
        input.avatarTapped
            .sink(receiveValue: { [weak self] userModel in
                self?.onAvartarTapped?(String(describing: userModel.playgroundId))
            }).store(in: cancelBag)
        
        input.pullToRefreshTriggered
            .withUnretained(self)
            .sink(receiveValue: { [weak self] _ in
                self?.usecase.getRandomAcquaintances()
            }).store(in: cancelBag)
        
        return output
    }
}

extension PokeOnboardingViewModel {
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        self.usecase
            .randomAcquaintances
            .asDriver()
            .sink(receiveValue: { values in
                output.randomAcquaintance.send(values)
            }).store(in: cancelBag)
        
        self.usecase
            .pokedResponse
            .asDriver()
            .sink(receiveValue: { value in
                output.pokedResult.send(value)
            }).store(in: cancelBag)
        
        self.usecase
            .pokedResponse
            .sink { _ in
                ToastUtils.showMDSToast(type: .success, text: I18N.Poke.pokeSuccess)
            }.store(in: cancelBag)
        
        self.usecase
            .errorMessage
            .compactMap { $0 }
            .sink { message in
                ToastUtils.showMDSToast(type: .alert, text: message)
            }.store(in: cancelBag)
    }
}
