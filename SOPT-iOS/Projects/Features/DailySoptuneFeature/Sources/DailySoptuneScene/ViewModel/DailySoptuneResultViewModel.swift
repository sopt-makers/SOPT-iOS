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

public class DailySoptuneResultViewModel: DailySoptuneResultViewModelType {
    
    public var onNaviBackTap: (() -> Void)?
    public var onReceiveTodaysFortuneCardTap: (() -> Void)?
    
    // MARK: - Properties

    private let useCase: DailySoptuneUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let receiveTodaysFortuneCardTap: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let todaysFortuneCard = PassthroughSubject<DailySoptuneCardModel, Never>()
        let randomUser = PassthroughSubject<PokeRandomUserInfoModel, Never>()
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
            .sink { [weak self] _ in
                self?.onNaviBackTap?()
                self?.useCase.getRandomUser()
            }.store(in: cancelBag)
        
        input.receiveTodaysFortuneCardTap
            .sink { [weak self] _ in
                self?.onReceiveTodaysFortuneCardTap?()
                self?.useCase.getTodaysFortuneCard()
            }.store(in: cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        useCase.todaysFortuneCard
            .subscribe(output.todaysFortuneCard)
            .store(in: cancelBag)
        
        useCase.randomUser
            .asDriver()
            .sink(receiveValue: { values in
                output.randomUser.send(values[0])
            }).store(in: cancelBag)
    }
    
    func setCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일 EEEE"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: Date())
    }
}
