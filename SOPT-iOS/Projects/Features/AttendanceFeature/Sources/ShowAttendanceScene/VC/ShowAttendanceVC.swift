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

public final class ShowAttendanceVC: UIViewController, ShowAttendanceViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: ShowAttendanceViewModel
    public var factory: AttendanceFeatureViewBuildable
    private var cancelBag = CancelBag()
    
    public var sceneType: AttendanceScheduleType {
        get {
            return self.viewModel.sceneType ?? .scheduledDay
        } set(type) {
            self.viewModel.sceneType = type
        }
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
    
    private let attendanceButton: OPCustomButton = {
        let button = OPCustomButton()
        button.titleLabel!.setTypoStyle(DSKitFontFamily.Suit.bold.font(size: 18))
        return button
    }()
    
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
        view.addSubviews(navibar, containerScrollView, attendanceButton)
        containerScrollView.addSubview(contentView)
        contentView.addSubviews(headerScheduleView, attendanceScoreView)
        
        navibar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(attendanceButton.snp.top)
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
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        attendanceButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
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
        
        attendanceButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                let vc = owner.factory.makeAttendanceVC().viewController
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: false)
            }
            .store(in: self.cancelBag)
        
        let input = ShowAttendanceViewModel.Input(viewDidLoad: viewdidload.asDriver(),
                                                  refreshButtonTapped: navibar.rightButtonTapped)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$scheduleModel
            .sink(receiveValue: { [weak self] model in
                guard let self, let model else { return }
                
                if self.viewModel.sceneType == .scheduledDay {
                    self.sceneType = .scheduledDay
                    self.setScheduledData(model)
                    self.headerScheduleView.updateLayout(.scheduledDay)
                    self.setAttendanceButton(isEnabled: true, title: "\(model.name) \(I18N.Attendance.takeAttendance)")
                } else {
                    self.sceneType = .unscheduledDay
                    self.headerScheduleView.updateLayout(.unscheduledDay)
                    self.setAttendanceButton(isEnabled: false)
                }
            })
            .store(in: self.cancelBag)
        
        output.$scoreModel
            .sink { model in
                guard let model else { return }
                self.setScoreData(model)
            }.store(in: self.cancelBag)
    }
    
    @objc
    private func refreshButtonDidTap() {
        print("refresh button did tap")
    }
    
    private func setScheduledData(_ model: AttendanceScheduleModel) {
        
        if self.sceneType == .scheduledDay {
            guard let date = viewModel.formatTimeInterval(startDate: model.startDate, endDate: model.endDate) else { return }
            headerScheduleView.setData(date: date,
                                       place: model.location,
                                       todaySchedule: model.name,
                                       description: model.message)
        }
    }
    
    private func setScoreData(_ model: AttendanceScoreModel) {
        attendanceScoreView.setMyInfoData(name: model.name, part: model.part, generation: model.generation,
                                          count: model.score)
        attendanceScoreView.setMyTotalScoreData(attendance: model.total.attendance, tardy: model.total.tardy, absent: model.total.absent)
        attendanceScoreView.setMyAttendanceTableData(model.attendances)
    }
    
    /// 하단 출석하기 버튼 (비)활성화
    private func setAttendanceButton(isEnabled: Bool, title: String? = "") {
        attendanceButton.isEnabled = isEnabled
        attendanceButton.setTitle(title, for: .normal)
    }
}
