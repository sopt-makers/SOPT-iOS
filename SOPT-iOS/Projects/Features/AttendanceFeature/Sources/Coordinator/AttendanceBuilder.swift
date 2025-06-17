//
//  AttendanceBuilder.swift
//  AttendanceFeatureInterface
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import AttendanceFeatureInterface

public
final class AttendanceBuilder {
    @Injected public var attendanceRepository: AttendanceRepositoryInterface
    @Injected public var showAttendanceRepository: ShowAttendanceRepositoryInterface
    
    public init() { }
}

extension AttendanceBuilder: AttendanceFeatureBuildable {
    public func makeShowAttendanceVC() -> ShowAttendancePresentable {
        let useCase = DefaultShowAttendanceUseCase(repository: showAttendanceRepository)
        let viewModel = ShowAttendanceViewModel(useCase: useCase)
        let showAttendanceVC = ShowAttendanceVC(viewModel: viewModel)
        return (showAttendanceVC, viewModel)
    }
    
    public func makeAttendanceVC(lectureRound: AttendanceRoundModel, dismissCompletion: (() -> Void)?) -> AttendancePresentable {
        let useCase = DefaultAttendanceUseCase(repository: attendanceRepository)
        let viewModel = AttendanceViewModel(useCase: useCase, lectureRound: lectureRound)
        let attendanceVC = AttendanceVC(viewModel: viewModel)
        attendanceVC.dismissCompletion = dismissCompletion
        return (attendanceVC, viewModel)
    }
}
