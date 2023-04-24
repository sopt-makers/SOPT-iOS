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
    }
    
    // MARK: - UI Components
    
    private let todayAttendanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.gray80.color
        return view
    }()
    
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
        addSubviews(lineView, todayAttendanceStackView)
        
        lineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Metric.lineInset)
            $0.height.equalTo(Metric.lineHeight)
        }
        
        todayAttendanceStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setTodayAttendances(_ attendances: [AttendanceStepModel]) {
                
        todayAttendanceStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for attendance in attendances {
            let attendanceStepView = OPAttendanceStepView(step: attendance)
            todayAttendanceStackView.addArrangedSubview(attendanceStepView)
            attendanceStepView.snp.makeConstraints {
                $0.height.equalTo(Metric.attendanceStepHeight)
                $0.width.equalTo(Metric.attendanceStepWidth)
            }
        }
    }
}
