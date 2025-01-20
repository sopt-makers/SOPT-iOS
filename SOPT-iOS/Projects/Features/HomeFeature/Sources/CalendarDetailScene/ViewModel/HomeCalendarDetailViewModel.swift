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
    }
    
    // MARK: - Outputs
    
    public struct Output { 
        let calendarDetailModel = PassthroughSubject<[HomeCalendarDetailPresentationModel], Never>()
    }
    
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
                let calendarDetailInfo = owner.transformToPresentationModel(model: calendarDetailModel)
                output.calendarDetailModel.send(calendarDetailInfo)
            }.store(in: cancelBag)
        
        return output
    }
}

extension HomeCalendarDetailViewModel {
    private func transformToPresentationModel(model: [HomeCalendarDetailModel]) -> [HomeCalendarDetailPresentationModel] {
        return model.map { calendar in
            HomeCalendarDetailPresentationModel(
                date: calendar.date, 
                title: calendar.title,
                type: calendar.type,
                isRecentSchedule: calendar.isRecentSchedule
            )
        }
    }
}
