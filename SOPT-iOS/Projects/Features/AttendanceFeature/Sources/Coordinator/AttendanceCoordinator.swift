//
//  AttendanceCoordinator.swift
//  AttendanceFeatureInterface
//
//  Created by Junho Lee on 2023/06/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
import AttendanceFeatureInterface

public
final class AttendanceCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
    
    private let factory: AttendanceFeatureViewBuildable
    private let router: Router
    
    public init(router: Router, factory: AttendanceFeatureViewBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showShowAttendance()
    }
    
    private func showShowAttendance() {
        var showAttendance = factory.makeShowAttendanceVC()
        showAttendance.onNaviBackTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        showAttendance.onAttendanceButtonTap = { [weak self] lectureRound, completion in
            self?.showAttendance(lectureRound, completion)
        }
        router.push(showAttendance)
    }
    
    internal func showAttendance(_ lectureRound: AttendanceRoundModel, _ dismissCompletion: (() -> Void)?) {
        let attendance = factory.makeAttendanceVC(
            lectureRound: lectureRound, dismissCompletion: dismissCompletion
        )
        router.present(
            attendance,
            animated: true,
            modalPresentationSytle: .overFullScreen,
            modalTransitionStyle: .crossDissolve
        )
    }
}
