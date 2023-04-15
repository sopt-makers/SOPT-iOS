//
//  ShowAttendanceViewModel.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public final class ShowAttendanceViewModel: ViewModelType {

    // MARK: - Properties
    
    private let useCase: ShowAttendanceUseCase
    private var cancelBag = CancelBag()
    public var sceneType: AttendanceScheduleType?
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let refreshButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public class Output {
        @Published var scheduleModel: AttendanceScheduleModel?
        @Published var scoreModel: AttendanceScoreModel?

    }
    
    // MARK: - init
  
    public init(useCase: ShowAttendanceUseCase) {
        self.useCase = useCase
    }
}

extension ShowAttendanceViewModel {
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        self.bindOutput(output: output, cancelBag: cancelBag)
       
        input.viewDidLoad.merge(with: input.refreshButtonTapped)
            .withUnretained(self)
            .sink { owner, _ in
//                if owner.sceneType == .unscheduledDay {
//                    owner.useCase.
//                } else {
//
//                }
                owner.useCase.fetchAttendanceSchedule()
                owner.useCase.fetchAttendanceScore()
            }.store(in: cancelBag)
    
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let fetchedSchedule = self.useCase.attendanceScheduleFetched
        let fetchedScore = self.useCase.attendanceScoreFetched
        
        fetchedSchedule.asDriver()
            .sink(receiveValue: { model in
                output.scheduleModel = model
            })
            .store(in: cancelBag)
        
        fetchedScore.asDriver()
            .sink(receiveValue: { model in
                output.scoreModel = model
            })
            .store(in: cancelBag)
    }
}
