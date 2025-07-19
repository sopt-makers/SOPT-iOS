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
import Domain
import DSKit

import SnapKit
import Then

import BaseFeatureDependency
import SplashFeatureInterface

public class NoticePopUpVC: UIViewController, LegacyNoticePopUpViewControllable, NoticePopUpViewControllable {
    
    // MARK: - Properties
    
    public var closeButtonTappedWithCheck = PassthroughSubject<Bool, Never>()
    
    private var type: NoticePopUpType?
    
    // MARK: - UI Components
    
    private lazy var backgroundDimmerView = CustomDimmerView(self)
    
    private let noticeView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 14
    }
    
    private let noticeTitleLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.textAlignment = .left
    }
    
    private let noticeContentView = UILabel().then {
        $0.font = DSKitFontFamily.Suit.regular.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray100.color
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let checkBoxButton = UIButton(type: .custom).then {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = DSKitAsset.Colors.gray10.color
        config.background.backgroundColor = .clear
        config.imagePadding = 6
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        var titleAttributed = AttributedString(I18N.Notice.didCheck)
        titleAttributed.font = DSKitFontFamily.Suit.regular.font(size: 14)
        titleAttributed.foregroundColor = DSKitAsset.Colors.gray10.color
        
        config.attributedTitle = titleAttributed
        $0.setImage(DSKitAsset.Assets.btnCheckInactive.image, for: .normal)
        $0.setImage(DSKitAsset.Assets.btnCheckActive.image, for: .selected)
        $0.configuration = config
    }
    
    private let updateButton = AppCustomButton(title: I18N.Notice.goToUpdate)
        .setConfigForState(enabledFont: DSKitFontFamily.Suit.semiBold.font(size: 16))
    
    
    private let closeButton = AppCustomButton(title: I18N.Notice.close)
        .setConfigForState(bgColor: DSKitAsset.Colors.gray600.color,
                           enabledTextColor: DSKitAsset.Colors.white.color,
                           enabledFont: DSKitFontFamily.Suit.semiBold.font(size: 16))
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [closeButton, updateButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 7
    }
    
    private lazy var checkButtonStackView = UIStackView(
        arrangedSubviews: [checkBoxButton, buttonStackView])
        .then {
            $0.axis = .vertical
            $0.alignment = .leading
            $0.spacing = 20
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
    
    public func setData(type: NoticePopUpType, model: AppNoticeModel) {
        self.type = type
        self.noticeContentView.text = model.notice
        self.noticeTitleLabel.text = model.title
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
        noticeView.addSubviews(noticeTitleLabel, noticeContentView, checkButtonStackView)
        
        backgroundDimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noticeView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(36)
        }
        
        noticeTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
        
        noticeContentView.snp.makeConstraints { make in
            make.top.equalTo(noticeTitleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(checkButtonStackView.snp.top).offset(-24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        updateButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        checkButtonStackViewLayout()
    }
    
    private func checkButtonStackViewLayout() {
        switch type {
        case .forceUpdate:
            checkButtonStackView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(20)
            }
        case .recommendUpdate, .none:
            checkButtonStackView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(24)
            }
        }
        
    }
    
    private func changeLayout(with type: NoticePopUpType) {
        switch type {
        case .forceUpdate:
            self.checkBoxButton.isHidden = true
            self.closeButton.isHidden = true
        case .recommendUpdate:
            self.checkBoxButton.isHidden = false
        }
    }
}
