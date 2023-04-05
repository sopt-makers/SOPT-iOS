//
//  NoticePopUpVC.swift
//  Presentation
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import DSKit

import SnapKit
import Then

import SplashFeatureInterface

public class NoticePopUpVC: UIViewController, NoticePopUpViewControllable {
    
    // MARK: - Properties
    
    public var closeButtonTappedWithCheck = PassthroughSubject<Bool, Never>()
    
    private var type: NoticePopUpType?
    
    // MARK: - UI Components
    
    private lazy var backgroundDimmerView = CustomDimmerView(self)
    
    private let noticeView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let noticeTitleLabel = UILabel().then {
        $0.text = I18N.Notice.notice
        $0.font = .SoptampFont.subtitle3
        $0.textColor = DSKitAsset.Colors.soptampPurple300.color
        $0.backgroundColor = DSKitAsset.Colors.soptampPurple100.color
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4
    }
    
    private let noticeContentTextView = UITextView().then {
        $0.text = I18N.Notice.notice
        $0.isEditable = false
        $0.font = .SoptampFont.caption3
        $0.textColor = DSKitAsset.Colors.soptampGray900.color
        $0.textAlignment = .center
    }
    
    private let checkBoxButton = UIButton(type: .custom).then {
        $0.setImage(DSKitAsset.Assets.icCheckBox.image, for: .normal)
        $0.setImage(DSKitAsset.Assets.icCheckBoxFill.image, for: .selected)
        $0.setAttributedTitle(NSAttributedString(string: I18N.Notice.didCheck,
                                                 attributes: [.font: UIFont.SoptampFont.caption3,
                                                    .foregroundColor: DSKitAsset.Colors.soptampGray600.color]),
                              for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }

    private let updateButton = STCustomButton(title: I18N.Notice.goToUpdate)
    
    private let closeButton = UIButton(type: .system).then {
        $0.setAttributedTitle(NSAttributedString(string: I18N.Notice.close,
                                                 attributes: [.font: UIFont.SoptampFont.h3,
                                                              .foregroundColor: DSKitAsset.Colors.soptampGray500.color]), for: .normal)
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
        self.setAddTarget()
    }
}

// MARK: - Methods

extension NoticePopUpVC {
    
    public func setData(type: NoticePopUpType, content: String) {
        self.type = type
        self.noticeContentTextView.text = content
        self.changeLayout(with: type)
    }
    
    private func setAddTarget() {
        self.checkBoxButton.addTarget(self, action: #selector(checkBoxButtonDitTap), for: .touchUpInside)
        self.updateButton.addTarget(self, action: #selector(updateButtonDidTap), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - @objc Function

extension NoticePopUpVC {
    @objc private func checkBoxButtonDitTap() {
        self.checkBoxButton.isSelected.toggle()
    }
    
    @objc private func updateButtonDidTap() {
        if let url = URL(string: ExternalURL.AppStore.appStoreLink) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func closeButtonDidTap() {
        guard let type = self.type else { return }
        
        switch type {
        case .forceUpdate:
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        case .recommendUpdate:
            self.closeButtonTappedWithCheck.send(self.checkBoxButton.isSelected)
        }
    }
}

// MARK: - UI & Layout

extension NoticePopUpVC {
    private func setUI() {
        view.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(backgroundDimmerView, noticeView)
        noticeView.addSubviews(noticeTitleLabel, noticeContentTextView, buttonStackView)
        
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
        
        noticeContentTextView.snp.makeConstraints { make in
            make.top.equalTo(noticeTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(283)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(noticeContentTextView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.width.equalTo(95)
        }
        
        updateButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    private func changeLayout(with type: NoticePopUpType) {
        switch type {
        case .forceUpdate:
            self.checkBoxButton.isHidden = true
        case .recommendUpdate:
            self.checkBoxButton.isHidden = false
        }
    }
}
