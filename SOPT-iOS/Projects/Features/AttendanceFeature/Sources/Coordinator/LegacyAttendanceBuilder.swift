//
//  LegacyAttendanceBuilder.swift
//  AttendanceFeatureInterface
//
//  Created by Junho Lee on 2023/06/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import AttendanceFeatureInterface

public
final class LegacyAttendanceBuilder {
    @Injected public var attendanceRepository: AttendanceRepositoryInterface
    @Injected public var showAttendanceRepository: ShowAttendanceRepositoryInterface
    
    public init() { }
}

extension LegacyAttendanceBuilder: LegacyAttendanceFeatureBuildable {
    public func makeShowAttendanceVC() -> LegacyShowAttendanceViewControllable {
        let useCase = DefaultShowAttendanceUseCase(repository: showAttendanceRepository)
        let viewModel = ShowAttendanceViewModel(useCase: useCase)
        let showAttendanceVC = ShowAttendanceVC(viewModel: viewModel)
        return showAttendanceVC
    }

    public func makeAttendanceVC(lectureRound: AttendanceRoundModel, dismissCompletion: (() -> Void)?) -> LegacyAttendanceViewControllable {
        let useCase = DefaultAttendanceUseCase(repository: attendanceRepository)
        let viewModel = AttendanceViewModel(useCase: useCase, lectureRound: lectureRound)
        let attendanceVC = AttendanceVC(viewModel: viewModel)
        attendanceVC.dismissCompletion = dismissCompletion
        return attendanceVC
    }
}
