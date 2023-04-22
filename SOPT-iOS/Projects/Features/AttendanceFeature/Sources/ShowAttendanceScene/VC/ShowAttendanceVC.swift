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
        sv.isExclusiveTouch = true
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
    
    private let attendanceButton: OPCustomButton = {
        let button = OPCustomButton()
        button.titleLabel!.setTypoStyle(.Attendance.h1)
        button.isHidden = true
        button.isEnabled = true
        return button
    }()
    
    private let refresher: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .gray
        return rf
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
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
        self.setUI()
        self.setLayout()
        self.swipeRecognizer()
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
        view.addSubviews(navibar, containerScrollView, attendanceButton)
        containerScrollView.addSubview(contentView)
        contentView.addSubviews(headerScheduleView, attendanceScoreView)
        attendanceScoreView.addSubview(infoButton)
        
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
            $0.width.equalToSuperview()
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
        
        infoButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.trailing.equalToSuperview().inset(32)
            $0.width.height.equalTo(24)
        }
    }
}

// MARK: - Methods

extension ShowAttendanceVC {
    
    private func bindViewModels() {
        
        let viewWillAppear = viewWillAppear.asDriver()
        let refreshStarted = refresher.publisher(for: .valueChanged)
            .mapVoid()
            .asDriver()
        
        attendanceButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                let vc = owner.factory.makeAttendanceVC(lectureRound: owner.viewModel.lectureRound).viewController
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true)
            }
            .store(in: self.cancelBag)
        
        let input = ShowAttendanceViewModel.Input(viewWillAppear: viewWillAppear,
                                                  refreshStarted: refreshStarted)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$scheduleModel
            .sink(receiveValue: { [weak self] model in
                guard let self, let model else { return }
                
                if self.viewModel.sceneType == .scheduledDay {
                    self.sceneType = .scheduledDay
                    self.setScheduledData(model)
                    self.headerScheduleView.updateLayout(.scheduledDay)
                    self.attendanceButton.isHidden = false
                } else {
                    self.sceneType = .unscheduledDay
                    self.headerScheduleView.updateLayout(.unscheduledDay)
                    self.attendanceButton.isHidden = true
                }
                self.endRefresh()
            })
            .store(in: self.cancelBag)
        
        output.$scoreModel
            .sink { model in
                guard let model else { return }
                self.infoButton.setImage(DSKitAsset.Assets.opInfo.image, for: .normal)
                self.setScoreData(model)
                self.endRefresh()
            }.store(in: self.cancelBag)
        
        output.$todayAttendances
            .withUnretained(self)
            .sink { owner, model in
                guard let model else { return }
                owner.headerScheduleView.setAttendanceInfo(model, true)
            }
            .store(in: self.cancelBag)
        
        output.attendanceButtonInfo
            .withUnretained(self)
            .sink { owner, info in
                owner.setAttendanceButton(title: info.title, isEnabled: info.isEnalbed)
            }
            .store(in: self.cancelBag)
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
    
    private func setAttendanceButton(title: String, isEnabled: Bool) {
        attendanceButton.isEnabled = isEnabled
        isEnabled ? attendanceButton.setTitle(title, for: .normal) : attendanceButton.setTitle(title, for: .disabled)
    }
    
    @objc
    private func infoButtonDidTap() {
        if let url = URL(string: "https://sopt.org/rules") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ShowAttendanceVC: UIGestureRecognizerDelegate {
    
    private func swipeRecognizer() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}
