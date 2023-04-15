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
import Domain
import DSKit

import SnapKit
import AttendanceFeatureInterface

private enum SessionType: String, CaseIterable {
    case noSession = "NO_SESSION"
    case hasAttendance = "HAS_ATTENDANCE"
    case noAttendance = "NO_ATTENDANCE"
}

public final class ShowAttendanceVC: UIViewController, ShowAttendanceViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: ShowAttendanceViewModel
    public var factory: AttendanceFeatureViewBuildable
    private var cancelBag = CancelBag()
    
    public var sceneType: AttendanceScheduleType {
        return self.viewModel.sceneType ?? .scheduledDay
    }
    private var viewdidload = PassthroughSubject<Void, Never>()
  
    // MARK: - UI Components
    
    private let containerScrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var navibar = OPNavigationBar(self, type: .bothButtons)
        .addMiddleLabel(title: I18N.Attendance.attendance)
        .addRightButtonAction {
            self.refreshButtonDidTap()
        }
    
    private lazy var headerScheduleView: TodayScheduleView = {
        switch sceneType {
        case .unscheduledDay:
            return TodayScheduleView(type: .unscheduledDay)
        case .scheduledDay:
            return TodayScheduleView(type: .scheduledDay)
        }
    }()
    
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
        self.bindViews()
        self.setUI()
        self.setLayout()
        self.viewdidload.send(())
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
        containerScrollView.addSubview(contentView)
        contentView.addSubviews(headerScheduleView, attendanceScoreView)
        
        navibar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerScheduleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        attendanceScoreView.snp.makeConstraints {
            $0.top.equalTo(headerScheduleView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension ShowAttendanceVC {
    
    private func bindViews() {
        
        navibar.rightButtonTapped
            .asDriver()
            .withUnretained(self)
            .sink { owner, _ in
                owner.refreshButtonDidTap()
            }.store(in: self.cancelBag)
    }
  
    private func bindViewModels() {
        
        let input = ShowAttendanceViewModel.Input(viewDidLoad: viewdidload.asDriver(),
                                                  refreshButtonTapped: navibar.rightButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$scheduleModel
            .compactMap { $0 }
            .sink { model in
                if model.type == "NO_SESSION" {
                    self.viewModel.sceneType = .unscheduledDay
                } else {
                    self.viewModel.sceneType = .scheduledDay
                    self.setData(model)
                }
//                print("스케쥴 데이터가 잘 넘어왓을까요?", model)
            }.store(in: self.cancelBag)
        
        output.$scoreModel
            .sink { model in
//                print("스코어 데이터가 잘 넘어왔을까여?]", model)
            }.store(in: self.cancelBag)
    }
    
    @objc
    private func refreshButtonDidTap() {
        print("refresh button did tap")
    }
    
    private func setData(_ model: AttendanceScheduleModel) {
        if self.sceneType == .scheduledDay {
            guard let date = viewModel.formatTimeInterval(startDate: model.startDate, endDate: model.endDate) else { return }
            headerScheduleView.setData(date: date,
                                       place: model.location,
                                       todaySchedule: model.name,
                                       description: model.message)
        }
    }
    
    
}
