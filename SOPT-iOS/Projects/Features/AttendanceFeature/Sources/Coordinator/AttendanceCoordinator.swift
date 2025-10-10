//
//  AttendanceCoordinator.swift
//  AttendanceFeatureInterface
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
import AttendanceFeatureInterface

public final class AttendanceCoordinator: DefaultCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private let factory: AttendanceFeatureBuildable
    private weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: AttendanceFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showShowAttendance()
    }
    
    // MARK: - Navigation
    
    private func showShowAttendance() {
        var showAttendance = factory.makeShowAttendanceVC(coordinator: self)
        
        showAttendance.vc.onNaviBackTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        showAttendance.vc.onAttendanceButtonTap = { [weak self] lectureRound, completion in
            self?.showAttendance(lectureRound, completion)
        }
        
        navigationController?.pushViewController(showAttendance.vc, animated: true)
    }
    
    internal func showAttendance(_ lectureRound: AttendanceRoundModel, _ dismissCompletion: (() -> Void)?) {
        let attendance = factory.makeAttendanceVC(
            lectureRound: lectureRound,
            dismissCompletion: dismissCompletion
        )
        
        attendance.vc.modalPresentationStyle = .overFullScreen
        attendance.vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(attendance.vc, animated: true)
    }
}
