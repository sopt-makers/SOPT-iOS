//
//  HomeCalendarDetailViewModel.swift
//  HomeFeatureDemo
//
//  Created by 강윤서 on 12/12/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain
import HomeFeatureInterface


public class HomeCalendarDetailViewModel: HomeCalendarDetailViewModelType {
    
    // MARK: - Properties
    
    private let useCase: HomeUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let naviBackButtonTap: Driver<Void>
        let onAttendanceButtonTap: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public struct Output { 
        let calendarDetailModel = PassthroughSubject<[HomeCalendarDetailPresentationModel], Never>()
    }
    
    // MARK: - SoptlogCoordinatable

    public var onNaviBackButtonTap: (() -> Void)?
    public var onAttendanceButtonTap: (() -> Void)?
    
    // MARK: - initialization
    
    public init(useCase: HomeUseCase, cancelBag: CancelBag = CancelBag()) {
        self.useCase = useCase
        self.cancelBag = cancelBag
    }
}

extension HomeCalendarDetailViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .flatMap(useCase.getCalendarDetail)
            .withUnretained(self)
            .sink { owner, calendarDetailModel in
                let calendarDetailInfo = calendarDetailModel.map{ $0.toPresentation() }
                output.calendarDetailModel.send(calendarDetailInfo)
            }.store(in: cancelBag)
        
        input.naviBackButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackButtonTap?()
            }.store(in: cancelBag)
        
        input.onAttendanceButtonTap
            .withUnretained(self)
            .sink { owner, _ in
                owner.onAttendanceButtonTap?()
            }.store(in: cancelBag)
        
        return output
    }
}

extension HomeCalendarDetailModel {
    func toPresentation() -> HomeCalendarDetailPresentationModel {
        return HomeCalendarDetailPresentationModel(
            date: self.date,
            title: self.title,
            type: self.type,
            isRecentSchedule: self.isRecentSchedule
        )
    }
}
