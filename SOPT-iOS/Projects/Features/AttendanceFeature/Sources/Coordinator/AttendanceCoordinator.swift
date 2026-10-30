//
//  AttendanceCoordinator.swift
//  AttendanceFeatureInterface
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import SafariServices

import Core
import Domain
import DSKit
import BaseFeatureDependency
import AttendanceFeatureInterface

public final class AttendanceCoordinator: BaseCoordinator {
    
    // MARK: - Properties
        
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
        
        showAttendance.vm.onNaviBackTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        showAttendance.vm.onAttendanceButtonTap = { [weak self] lectureRound, completion in
            self?.showAttendance(lectureRound, completion)
        }
        
        showAttendance.vm.onInfoButtonTap = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.showRules()
            }
        }

        navigationController?.pushViewController(showAttendance.vc, animated: true)
    }

    private func showRules() {
        guard let url = URL(string: "https://sopt.org/rules") else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.playgroundStyle()
        navigationController?.present(safariViewController, animated: true)
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
