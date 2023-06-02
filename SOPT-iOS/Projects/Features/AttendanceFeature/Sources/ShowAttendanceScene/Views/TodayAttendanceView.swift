//
//  TodayAttendanceView.swift
//  AttendanceFeature
//
//  Created by 김영인 on 2023/04/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import DSKit

/*
 출석 조회하기 뷰의 상단 오늘의 일정 중
 오늘의 출석현황을 보여주는 뷰 입니다.
 */

final class TodayAttendanceView: UIView {
    
    private enum Metric {
        static let lineHeight = 1.f
        static let lineInset = 12.f
        
        static let attendanceStepHeight = 51.f
        static let attendanceStepWidth = 47.f
        
        static let screenWidth = UIScreen.main.bounds.width
    }
    
    // MARK: - UI Components
    
    private let todayAttendanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let lineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var firstLineView = OPLineView()
    private var secondLineView = OPLineView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension TodayAttendanceView {
    
    private func setLayout() {
        lineStackView.addArrangedSubviews(firstLineView, secondLineView)
        addSubviews(lineStackView, todayAttendanceStackView)
        
        [firstLineView, secondLineView].forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview().dividedBy(2)
                $0.height.equalTo(Metric.lineHeight)
            }
        }
        
        lineStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Metric.lineInset)
        }
        
        todayAttendanceStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setTodayAttendances(_ attendances: [AttendanceStepModel], attendanceType: TakenAttendanceType) {
        todayAttendanceStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        [firstLineView, secondLineView].forEach { $0.setColor(type: .unCheck) }
        
        for attendance in attendances {
            let attendanceStepView = OPAttendanceStepView(step: attendance)
            todayAttendanceStackView.addArrangedSubview(attendanceStepView)
            attendanceStepView.snp.makeConstraints {
                $0.height.equalTo(Metric.attendanceStepHeight)
                $0.width.equalTo(Metric.attendanceStepWidth)
            }
        }
        
        /// 1차 출석까지 한 경우 첫 번째 라인 색 변경
        if attendanceType != .notYet {
            firstLineView.setColor(type: .check)
        }
        
        /// 2차 출석까지 한 경우 두 번째 라인 색까지 변경
        if attendanceType == .second {
            secondLineView.setColor(type: .check)
        }
    }
}
