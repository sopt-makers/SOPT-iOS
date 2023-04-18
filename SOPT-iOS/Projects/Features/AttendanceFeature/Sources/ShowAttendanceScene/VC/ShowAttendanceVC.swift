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
    
    private var viewWillAppear = PassthroughSubject<Void, Never>()
  
    // MARK: - UI Components
    
    private lazy var containerScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.refreshControl = refresher
        return sv
    }()
    
    private let contentView = UIView()
    
    private lazy var navibar = OPNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Attendance.attendance)
    
    private lazy var headerScheduleView: TodayScheduleView = {
        switch sceneType {
        case .unscheduledDay:
            return TodayScheduleView(type: .unscheduledDay)
        case .scheduledDay:
            return TodayScheduleView(type: .scheduledDay)
        }
    }()
    
    private let attendanceScoreView = AttendanceScoreView()
    
    private let refresher: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .gray
        return rf
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
        self.setUI()
        self.setLayout()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppear.send(())
    }
}

// MARK: - UI & Layout

extension ShowAttendanceVC {
    
    private func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = DSKitAsset.Colors.black100.color
        containerScrollView.backgroundColor = DSKitAsset.Colors.black100.color
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
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
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
    
    private func bindViewModels() {
        
        let refreshStarted = refresher.publisher(for: .valueChanged)
            .mapVoid()
            .asDriver()
        
        let input = ShowAttendanceViewModel.Input(viewWillAppear: viewWillAppear.asDriver(),
                                                  refreshStarted: refreshStarted)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$scheduleModel
            .sink(receiveValue: { [weak self] model in
                guard let self, let model else { return }
                self.endRefresh()
                
                if self.viewModel.sceneType == .scheduledDay {
                    self.sceneType = .scheduledDay
                    self.setScheduledData(model)
                    self.headerScheduleView.updateLayout(.scheduledDay)
                } else {
                    self.sceneType = .unscheduledDay
                    self.headerScheduleView.updateLayout(.unscheduledDay)
                }
            })
            .store(in: self.cancelBag)
        
        output.$scoreModel
            .sink { model in
                guard let model else { return }
                self.endRefresh()
                self.setScoreData(model)
            }.store(in: self.cancelBag)
    }
    
    private func endRefresh() {
        self.refresher.endRefreshing()
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
        attendanceScoreView.setMyTotalScoreData(attendance: model.total.attendance, tardy: model.total.tardy, absent: model.total.absent, participate: model.total.participate)
        attendanceScoreView.setMyAttendanceTableData(model.attendances)
    }
}
