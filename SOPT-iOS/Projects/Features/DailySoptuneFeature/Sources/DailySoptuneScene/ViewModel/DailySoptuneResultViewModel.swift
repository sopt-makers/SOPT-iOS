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

public final class DailySoptuneResultViewModel: DailySoptuneResultViewModelType {
    
    public var onNaviBackButtonTapped: (() -> Void)?
    public var onReceiveTodaysFortuneCardTap: ((DailySoptuneCardModel) -> Void)?
    public var onKokButtonTapped: ((Domain.PokeUserModel) -> Core.Driver<(Domain.PokeUserModel, Domain.PokeMessageModel, isAnonymous: Bool)>)?
    public var onReceiveTodaysFortuneCardButtonTapped: ((Domain.DailySoptuneCardModel) -> Void)?
    
    // MARK: - Properties

    private let useCase: DailySoptuneUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewWillAppear: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let receiveTodaysFortuneCardTap: Driver<Void>
        let kokButtonTap: Driver<PokeUserModel?>
    }
    
    // MARK: - Outputs
    
    public struct Output {
//        let todaysFortuneCard = PassthroughSubject<DailySoptuneCardModel, Never>()
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
        
        input.viewWillAppear
            .sink { [weak self] _ in
                self?.useCase.getRandomUser()
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .sink { [weak self] _ in
                self?.onNaviBackButtonTapped?()
            }.store(in: cancelBag)
        
        input.receiveTodaysFortuneCardTap
            .sink { [weak self] _ in
                self?.useCase.getTodaysFortuneCard()
            }.store(in: cancelBag)
        
        input.kokButtonTap
            .compactMap { $0 }
            .flatMap { [weak self] userModel -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)> in
                guard let self, let value = self.onKokButtonTapped?(userModel) else { return .empty() }
                return value
            }
            .sink { [weak self] userModel, messageModel, isAnonymous in
                self?.useCase.poke(userId: userModel.userId, message: messageModel, isAnonymous: isAnonymous)
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.todaysFortuneCard
            .sink { [weak self] cardModel in
                self?.onReceiveTodaysFortuneCardButtonTapped?(cardModel)
            }
            .store(in: cancelBag)
        useCase.randomUser
            .asDriver()
            .sink(receiveValue: { values in
                output.randomUser.send(values[0])
            }).store(in: cancelBag)

        useCase.pokedResponse
            .subscribe(output.pokeResponse)
            .store(in: cancelBag)
    }
    
    func setCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: Date())
    }
}
