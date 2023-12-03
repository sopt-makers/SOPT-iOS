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
import BaseFeatureDependency
import SafariServices

public final class ShowAttendanceVC: UIViewController, ShowAttendanceViewControllable {
    
    // MARK: - Properties
    
    public var viewModel: ShowAttendanceViewModel
    private var cancelBag = CancelBag()
    
    public var sceneType: AttendanceScheduleType {
        return self.viewModel.sceneType ?? .unscheduledDay
    }
    
    private var viewWillAppear = PassthroughSubject<Void, Never>()
    
    // MARK: - ShowAttendanceCoordinatable
    
    public var onAttendanceButtonTap: ((AttendanceRoundModel, (() -> Void)?) -> Void)?
    public var onNaviBackTap: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var containerScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.refreshControl = refresher
        sv.isExclusiveTouch = true
        return sv
    }()
    
    private let contentView = UIView()
    
    private lazy var navibar = OPNavigationBar(self, type: .oneLeftButton, ignoreLeftButtonAction: true)
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
    
    private lazy var attendanceButtonStackView: UIStackView = {
        let stackView = UIStackView()
//        stackView.backgroundColor = DSKitAsset.Colors.gray900.color // 안쓰는거같음
        stackView.addArrangedSubview(attendanceButton)
        return stackView
    }()
    
    private let attendanceGradientView: AttendanceGradientView = .init(frame: CGRect(x: 0, y: 0, width: 500, height: 200))
    
    private let attendanceButton: OPCustomButton = {
        let button = OPCustomButton()
        button.titleLabel!.setTypoStyle(.Attendance.h1)
        button.isHidden = true
        button.isEnabled = false
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
    
    public init(viewModel: ShowAttendanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViews()
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
        self.view.backgroundColor = DSKitAsset.Colors.gray950.color
        containerScrollView.backgroundColor = DSKitAsset.Colors.gray950.color
    }
    
    private func setLayout() {
        view.addSubviews(navibar, containerScrollView, attendanceGradientView, attendanceButtonStackView)
        containerScrollView.addSubview(contentView)
        contentView.addSubviews(headerScheduleView, attendanceScoreView)
        attendanceScoreView.addSubview(infoButton)
        
        navibar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(attendanceButtonStackView.snp.top).offset(-2)
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
            $0.bottom.equalToSuperview()
        }
        
        attendanceGradientView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(13)
            $0.height.equalTo(229)
        }
        
        attendanceButtonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        attendanceButton.snp.makeConstraints {
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
    
    private func bindViews() {
        navibar.leftButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
    }
    
    private func bindViewModels() {
        
        let viewWillAppear = viewWillAppear.asDriver()
        let refreshStarted = refresher.publisher(for: .valueChanged)
            .mapVoid()
            .asDriver()
        
        attendanceButton.publisher(for: .touchUpInside)
            .withUnretained(self)
            .sink { owner, _ in
                owner.onAttendanceButtonTap?(owner.viewModel.lectureRound) {
                    owner.viewWillAppear.send(())
                }
            }
            .store(in: self.cancelBag)
        
        let input = ShowAttendanceViewModel.Input(viewWillAppear: viewWillAppear,
                                                  refreshStarted: refreshStarted)
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.$todayAttendances
            .combineLatest(output.$takenAttendanceType)
            .withUnretained(self)
            .sink { owner, model in
                guard let attendances = model.0, let type = model.1 else { return }
                UIView.animate(withDuration: 0.3) {
                    owner.headerScheduleView.setAttendanceInfo(attendances, true, attendanceType: type)
                }
            }
            .store(in: self.cancelBag)
        
        output.$scheduleModel
            .sink(receiveValue: { [weak self] model in
                guard let self, let model else { return }
                
                self.headerScheduleView.layoutIfNeeded()
                
                if self.sceneType == .scheduledDay {
                    self.headerScheduleView.scheduleType = .scheduledDay
                    self.setScheduledData(model)
                    self.attendanceButton.isHidden = false
                    self.attendanceGradientView.isHidden = false
                } else {
                    self.headerScheduleView.scheduleType = .unscheduledDay
                    self.attendanceButton.isHidden = true
                    self.attendanceGradientView.isHidden = true
                }
                self.endRefresh()
            })
            .store(in: self.cancelBag)
        
        output.$scoreModel
            .sink { [weak self] model in
                guard let self, let model else { return }
                self.infoButton.setImage(DSKitAsset.Assets.opInfo.image, for: .normal)
                self.setScoreData(model)
                self.endRefresh()
            }.store(in: self.cancelBag)
        
        output.attendanceButtonInfo
            .withUnretained(self)
            .sink { owner, info in
                owner.setAttendanceButton(title: info.title, isEnabled: info.isEnalbed)
            }
            .store(in: self.cancelBag)
        
        output.isLoading
            .withUnretained(self)
            .sink { owner, isLoading in
                if isLoading {
                    owner.showLoading()
                    owner.containerScrollView.isHidden = true
                } else {
                    owner.stopLoading()
                    owner.containerScrollView.isHidden = false
                }
            }
            .store(in: self.cancelBag)
    }
    
    private func endRefresh() {
        self.refresher.endRefreshing()
    }
    
    private func setScheduledData(_ model: AttendanceScheduleModel) {
        
        if self.sceneType == .scheduledDay {
            let date = viewModel.formatTimeInterval(startDate: model.startDate,
                                                    endDate: model.endDate)
            headerScheduleView.setData(date: date,
                                       place: model.location,
                                       todaySchedule: model.name,
                                       description: model.message)
        }
    }
    
    private func setScoreData(_ model: AttendanceScoreModel) {
        attendanceScoreView.setMyInfoData(name: model.name,
                                          part: model.part,
                                          generation: model.generation,
                                          count: model.score)
        attendanceScoreView.setMyTotalScoreData(attendance: model.total.attendance,
                                                tardy: model.total.tardy,
                                                absent: model.total.absent,
                                                participate: model.total.participate)
        attendanceScoreView.setMyAttendanceTableData(model.attendances)
    }
    
    private func setAttendanceButton(title: String, isEnabled: Bool) {
        attendanceButton.isEnabled = isEnabled
        isEnabled ? attendanceButton.setTitle(title, for: .normal) : attendanceButton.setTitle(title, for: .disabled)
    }
    
    @objc
    private func infoButtonDidTap() {
        
        showToast(message: I18N.Attendance.infoButtonToastMessage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let safariViewController = SFSafariViewController(url: URL(string: "https://sopt.org/rules")!)
            safariViewController.playgroundStyle()
            self?.present(safariViewController, animated: true)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ShowAttendanceVC: UIGestureRecognizerDelegate {
    
    private func swipeRecognizer() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}
