//
//  MyInformationWithScoreView.swift
//  AttendanceFeature
//
//  Created by devxsby on 2023/04/13.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import DSKit

final class MyInformationWithScoreView: UIView {
    
    // MARK: - UI Components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "32기 디자인파트 김솝트"
        label.font = .Main.body2
        label.textColor = DSKitAsset.Colors.gray60.color
        return label
    }()
    
    private let currentScoreLabel: UILabel = {
        let label = UILabel()
        let mainText = I18N.Attendance.currentAttendanceScore
        let pointText = "1점"
        let subText = I18N.Attendance.scoreIs
        let attributedString = NSMutableAttributedString(string: mainText + pointText + subText)
        
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.Main.body0,
                                        NSAttributedString.Key.foregroundColor: UIColor.white],
                                       range: NSRange(location: 0, length: mainText.count))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.Main.headline1,
                                        NSAttributedString.Key.foregroundColor: DSKitAsset.Colors.purple40.color],
                                       range: NSRange(location: mainText.count, length: pointText.count))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.Main.body0,
                                        NSAttributedString.Key.foregroundColor: UIColor.white],
                                       range: NSRange(location: mainText.count + pointText.count, length: subText.count))
        
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(DSKitAsset.Assets.opInfo.image, for: .normal)
        button.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension MyInformationWithScoreView {
    
    private func setLayout() {
        
        addSubviews(nameLabel, currentScoreLabel, infoButton)
        
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
}


// MARK: - Methods

extension MyInformationWithScoreView {
    
    @objc
    private func infoButtonDidTap() {
        if let url = URL(string: "https://sopt.org/rules") {
            UIApplication.shared.open(url)
        }
    }
    
    func setData() {
        
    }
}
