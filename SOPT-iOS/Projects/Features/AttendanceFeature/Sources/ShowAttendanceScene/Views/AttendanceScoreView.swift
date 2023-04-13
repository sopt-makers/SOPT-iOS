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
    
    // MARK: - UI Components
    
    /// 1. 나의 정보 및 현재 출석 점수 영역
    
    private let myInfoContainerView = MyInformationWithScoreView()
    
    /// 2. 전체 출결 점수 영역
    
    private let allScoreView = SingleScoreView(type: .all, count: 1)
    private let attendanceScoreView = SingleScoreView(type: .attendance, count: 1)
    private let tardyScoreView = SingleScoreView(type: .tardy)
    private let absentScoreView = SingleScoreView(type: .absent)
    
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
    
    private let attedncanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
        
    private let attendanceScoreDescriptiopnLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.text = I18N.Attendance.myAttendance
        label.textColor = DSKitAsset.Colors.gray60.color
        return label
    }()
    
    private lazy var myAttendanceStateContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [attendanceScoreDescriptiopnLabel, attedncanceStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()
    
    /// 4. 전체 묶음
    
    private lazy var containerStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [myInfoContainerView, myScoreContainerStackView, myAttendanceStateContainerStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        return stackView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
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
        addSubview(containerStackView)
        
        containerStackView.addSubviews(myInfoContainerView, myScoreContainerStackView, myAttendanceStateContainerStackView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(32)
        }
        
        myInfoContainerViewLayout()
        myScoreContainerViewLayout()
        myAttendanceStateContainerViewLayout()
    }
    
    private func myInfoContainerViewLayout () {
        
        myInfoContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func myScoreContainerViewLayout() {
        
        myScoreContainerStackView.addSubviews(allScoreView, attendanceScoreView, tardyScoreView, absentScoreView)
        
        myScoreContainerStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
    }
    
    private func myAttendanceStateContainerViewLayout() {
        myAttendanceStateContainerStackView.addSubviews(attendanceScoreDescriptiopnLabel, attedncanceStackView)
        
        // 반복문을 통해 뷰 생성 후 스택뷰에 추가
        for _ in 0..<3 {
            let singleAttendanceStateView = MyAttendanceStateView()
            
            attedncanceStackView.addArrangedSubview(singleAttendanceStateView)
            
            singleAttendanceStateView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(30)
            }
        }
        
        myAttendanceStateContainerStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        attendanceScoreDescriptiopnLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        attedncanceStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension AttendanceScoreView {
    
    func setData() {
        
    }
}
