//
//  ShowAttendanceVC.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Combine

import Core
import DSKit

import SnapKit
import AttendanceFeatureInterface

public class ShowAttendanceVC: UIViewController, ShowAttendanceViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: ShowAttendanceViewModel
    public var factory: AttendanceFeatureViewBuildable
    private var cancelBag = CancelBag()
  
    // MARK: - UI Components
    
    private let containerScrollView = UIScrollView()
    private lazy var navibar = OPNavigationBar(self, type: .bothButtons)
        .addMiddleLabel(title: I18N.Attendance.attendance)
        .addRightButtonAction {
            self.refreshButtonDidTap()
        }
    
    private let headerScheduleView = TodayScheduleView(type: .scheduledDay)
    private let attendanceScoreView = AttendanceScoreView()
    
    // MARK: - Initialization
    
    public init(viewModel: ShowAttendanceViewModel,
                factory: AttendanceFeatureViewBuildable) {
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setUI()
        self.setLayout()
        self.dummy()
    }
}

// MARK: - UI & Layout

extension ShowAttendanceVC {
    
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .black
        containerScrollView.backgroundColor = .black
    }
    
    private func setLayout() {
        view.addSubviews(navibar, containerScrollView)
        
        containerScrollView.addSubviews(headerScheduleView, attendanceScoreView)
        
        navibar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerScheduleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        attendanceScoreView.snp.makeConstraints {
            $0.top.equalTo(headerScheduleView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func dummy() {
        headerScheduleView.setData(date: "3월 23일 토요일 14:00 - 18:00",
                                   place: "건국대학교 꽥꽥오리관",
                                   todaySchedule: "1차 행사",
                                   description: "행사도 참여하고, 출석점수도 받고, 일석이조!")
    }
}

// MARK: - Methods

extension ShowAttendanceVC {
  
    private func bindViewModels() {
        let input = ShowAttendanceViewModel.Input()
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
    }
    
    
    @objc
    private func refreshButtonDidTap() {
        print("refresh button did tap")
    }
}
