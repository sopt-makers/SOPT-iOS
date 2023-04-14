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

/*
 출석 조회하기 뷰의 하단 출석 점수 현황을 보여주는 뷰 입니다.
 */

final class AttendanceScoreView: UIView {
    
    // MARK: - Properties

    private let tableViewHeight: CGFloat = 40
    private var tableViewDataSourceCount: Int = 5
    
    // MARK: - UI Components
    
    /// 1. 나의 정보 및 현재 출석 점수 영역
    
    private let myInfoContainerView = MyInformationWithScoreView()
    
    /// 2. 전체 출결 점수 영역
    
    private let allScoreView = SingleScoreView(type: .all, count: 5)
    private let attendanceScoreView = SingleScoreView(type: .attendance, count: 3)
    private let tardyScoreView = SingleScoreView(type: .tardy, count: 1)
    private let absentScoreView = SingleScoreView(type: .absent, count: 1)
    
    private lazy var myScoreContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allScoreView, attendanceScoreView, tardyScoreView, absentScoreView])
        stackView.backgroundColor = DSKitAsset.Colors.black40.color
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
        label.text = I18N.Attendance.myAttendance
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
        self.backgroundColor = DSKitAsset.Colors.black60.color
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func setLayout() {
        
        addSubviews(myInfoContainerView, myScoreContainerStackView, myAttendanceStateContainerView)
        myScoreContainerStackView.addSubviews(allScoreView, attendanceScoreView, tardyScoreView, absentScoreView)
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
    
    func updateTableviewHeight() {
        
        attendanceTableView.snp.updateConstraints {
            $0.height.equalTo(tableViewDataSourceCount * Int(tableViewHeight))
        }
    }
    
}

extension AttendanceScoreView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAttendanceStateTVC.className, for: indexPath) as? MyAttendanceStateTVC else { return UITableViewCell() }
        cell.selectionStyle = .none
        updateTableviewHeight()
        if indexPath.row == 2 {
            cell.setData(title: "\(indexPath.row+1)차 세미나",
                         image: DSKitAsset.Assets.opStateTardy.image,
                         date: "4월 \(indexPath.row*7+1)일")
        } else if indexPath.row == 0 {
            cell.setData(title: "\(indexPath.row+1)차 세미나",
                         image: DSKitAsset.Assets.opStateAttendance.image,
                         date: "4월 \(indexPath.row*7+1)일")
            
        } else if indexPath.row == 3 {
            cell.setData(title: "\(indexPath.row+1)차 세미나",
                         image: DSKitAsset.Assets.opStateAbsent.image,
                         date: "4월 \(indexPath.row*7+1)일")
        } else {
            cell.setData(title: "\(indexPath.row+1)차 세미나",
                         image: DSKitAsset.Assets.opStateAttendance.image,
                         date: "4월 \(indexPath.row*7+1)일")
        }
        return cell
    }
}
