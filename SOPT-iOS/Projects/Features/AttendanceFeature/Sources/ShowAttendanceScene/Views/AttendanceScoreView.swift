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

final class AttendanceScoreView: UIView {
    
    // MARK: - UI Components
    
    private let myInfoContainerView = UIView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "32기 디자인파트 김솝트"
        label.font = .Main.body2
        label.textColor = DSKitAsset.Colors.gray60.color
        return label
    }()
    
    private let currentScoreLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.Attendance.currentAttendanceScore + " 1점 " + I18N.Attendance.scoreIs
        label.font = .Main.body0
        label.textColor = .white
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(DSKitAsset.Assets.opInfo.image, for: .normal)
        button.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let myTotalScoreContainerPreView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.black40.color
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let myScoreContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = DSKitAsset.Colors.black40.color
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    
    /// 추가하기
    
        
    private let singleAttendanceStateView = UIView()
    
    private let attendanceScoreDescriptiopnLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.text = I18N.Attendance.myAttendance
        label.textColor = DSKitAsset.Colors.gray60.color
        return label
    }()
    
    private let attendanceStateButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "1차 세미나"
        configuration.baseForegroundColor = .white
        configuration.attributedTitle?.font = DSKitFontFamily.Suit.bold.font(size: 15)
        configuration.image = DSKitAsset.Assets.opStateAttendance.image
        configuration.imagePadding = 10
        configuration.titleAlignment = .leading
        let button = UIButton(configuration: configuration)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let attendanceStateDateLabel: UILabel = {
        let label = UILabel()
        label.font = .Main.body2
        label.text = "00월 00일"
        label.textColor = DSKitAsset.Colors.gray30.color
        return label
    }()
    
    private lazy var myAttendanceStateContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [attendanceScoreDescriptiopnLabel, singleAttendanceStateView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [myInfoContainerView, myTotalScoreContainerPreView, myAttendanceStateContainerStackView])
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

// MARK: - Methods

extension AttendanceScoreView {
    
    private func configureContentView() {
        self.backgroundColor = DSKitAsset.Colors.black60.color
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func setLayout() {
        addSubview(containerStackView)
        containerStackView.addSubviews(myInfoContainerView, myScoreContainerView, myAttendanceStateContainerStackView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(32)
        }
        
        myInfoContainerViewLayout()
        myScoreContainerViewLayout()
        myAttendanceStateContainerViewLayout()
        
        
    }
    
    private func myInfoContainerViewLayout () {
        myInfoContainerView.addSubviews(nameLabel, currentScoreLabel, infoButton)

        myInfoContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        currentScoreLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        infoButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    private func myScoreContainerViewLayout() {
        
        myTotalScoreContainerPreView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
    }
    
    private func myAttendanceStateContainerViewLayout() {
        
        myAttendanceStateContainerStackView.addSubviews(attendanceScoreDescriptiopnLabel, singleAttendanceStateView)
        
        singleAttendanceStateView.addSubviews(attendanceStateButton, attendanceStateDateLabel)
        
        myAttendanceStateContainerStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        attendanceScoreDescriptiopnLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        singleAttendanceStateView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }

        attendanceStateButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }

        attendanceStateDateLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
    
    @objc
    private func infoButtonDidTap() {
        print("info button did tap")
    }
}
