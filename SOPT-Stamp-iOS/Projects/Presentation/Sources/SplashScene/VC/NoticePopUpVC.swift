//
//  NoticePopUpVC.swift
//  Presentation
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Core
import DSKit

import SnapKit
import Then

public class NoticePopUpVC: UIViewController {
    
    // MARK: - Properties
    
    public var factory: ModuleFactoryInterface!
    
    // MARK: - UI Components
    
    private lazy var backgroundDimmerView = CustomDimmerView(self)
    
    private let noticeView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let noticeTitleLabel = UILabel().then {
        $0.text = I18N.Notice.notice
        $0.font = .subtitle3
        $0.textColor = DSKitAsset.Colors.purple300.color
        $0.backgroundColor = DSKitAsset.Colors.purple100.color
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
    }
    
    private let noticeContentLabel = UILabel().then {
        $0.text = I18N.Notice.notice
        $0.numberOfLines = 0
        $0.font = .caption3
        $0.textColor = DSKitAsset.Colors.gray900.color
        $0.textAlignment = .center
    }
    
    private let checkBoxButton = UIButton(type: .custom).then {
        $0.setImage(DSKitAsset.Assets.icCheckBox.image, for: .normal)
        $0.setImage(DSKitAsset.Assets.icCheckBoxFill.image, for: .selected)
        $0.setAttributedTitle(NSAttributedString(string: I18N.Notice.didCheck,
                                                 attributes: [.font: UIFont.caption3,
                                                    .foregroundColor: DSKitAsset.Colors.gray600.color]),
                              for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }

    private let updateButton = CustomButton(title: I18N.Notice.goToUpdate)
    
    private let closeButton = UIButton(type: .system).then {
        $0.setAttributedTitle(NSAttributedString(string: I18N.Notice.close,
                                                 attributes: [.font: UIFont.h3,
                                                              .foregroundColor: DSKitAsset.Colors.gray500.color]), for: .normal)
        $0.backgroundColor = .white
    }
    
    private lazy var buttonStackView = UIStackView(
        arrangedSubviews: [checkBoxButton, updateButton, closeButton])
        .then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 12
        }
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

// MARK: - UI & Layout

extension NoticePopUpVC {
    private func setUI() {
        view.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(backgroundDimmerView, noticeView)
        noticeView.addSubviews(noticeTitleLabel, noticeContentLabel, buttonStackView)
        
        backgroundDimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noticeView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        noticeTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(34)
        }
        
        noticeContentLabel.snp.makeConstraints { make in
            make.top.equalTo(noticeTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(noticeContentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
        
        updateButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
}
