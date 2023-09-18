//
//  AttendanceScoreView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/12.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit
import Domain

/*
 출석 조회하기 뷰의 하단 출석 점수 현황을 보여주는 뷰 입니다.
 */

final class AttendanceScoreView: UIView {
    
    // MARK: - Properties

    private var attendanceModelList = [AttendanceModel]()
    
    // MARK: - UI Components
    
    /// 1. 나의 정보 및 현재 출석 점수 영역
    
    private let myInfoContainerView = MyInformationWithScoreView()
    
    /// 2. 전체 출결 점수 영역
    
    private let attendanceScoreView = SingleScoreView(type: .attendance)
    private let tardyScoreView = SingleScoreView(type: .tardy)
    private let absentScoreView = SingleScoreView(type: .absent)
    private let participateScoreView = SingleScoreView(type: .participate)
    
    private lazy var myScoreContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [attendanceScoreView, tardyScoreView, absentScoreView, participateScoreView])
        stackView.backgroundColor = DSKitAsset.Colors.black60.color
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 8
        stackView.axis = .horizontal
        stackView.spacing = -10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    /// 3. 나의 출결 현황 영역
    
    private lazy var myAttendanceStateContainerView = UIView()
    
    private let attendanceScoreDescriptiopnLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.textColor = DSKitAsset.Colors.gray60.color
        return label
    }()
    
    private lazy var attendanceTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        registerCells()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension AttendanceScoreView {
    
    private func configureContentView() {
        self.backgroundColor = DSKitAsset.Colors.black80.color
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func setLayout() {
        
        addSubviews(myInfoContainerView, myScoreContainerStackView, myAttendanceStateContainerView)
        myAttendanceStateContainerView.addSubviews(attendanceScoreDescriptiopnLabel, attendanceTableView)
        
        myInfoContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(50)
        }
        
        myScoreContainerStackView.snp.makeConstraints {
            $0.top.equalTo(myInfoContainerView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(88)
        }
        
        myAttendanceStateContainerView.snp.makeConstraints {
            $0.top.equalTo(myScoreContainerStackView.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview().inset(32)
        }
        
        attendanceScoreDescriptiopnLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        attendanceTableView.snp.makeConstraints {
            $0.top.equalTo(attendanceScoreDescriptiopnLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Methods

extension AttendanceScoreView {
    
    private func registerCells() {
        attendanceTableView.delegate = self
        attendanceTableView.dataSource = self
        attendanceTableView.register(MyAttendanceStateTVC.self, forCellReuseIdentifier: MyAttendanceStateTVC.className)
    }
    
    private func updateTableviewHeight() {
        attendanceTableView.snp.updateConstraints {
            $0.height.equalTo(attendanceModelList.count * 40)
        }
    }
    
    func setMyInfoData(name: String, part: String, generation: Int, count: Double) {
        myInfoContainerView.setData(name: name, part: part, generation: generation, count: count)
    }
    
    func setMyTotalScoreData(attendance: Int, tardy: Int, absent: Int, participate: Int) {
        attendanceScoreView.setData(attendance, .attendance)
        tardyScoreView.setData(tardy, .tardy)
        absentScoreView.setData(absent, .absent)
        participateScoreView.setData(participate, .participate)
    }
    
    func setMyAttendanceTableData(_ model: [AttendanceModel]) {
        attendanceScoreDescriptiopnLabel.text = I18N.Attendance.myAttendance

        attendanceModelList = model
        updateTableviewHeight()
        attendanceTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AttendanceScoreView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        attendanceModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAttendanceStateTVC.className, for: indexPath) as? MyAttendanceStateTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setData(model: attendanceModelList[safe: indexPath.row]!)
        return cell
    }
}
