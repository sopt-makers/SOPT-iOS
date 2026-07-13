//
//  AlertVC.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core
import DSKit

public class AlertVC: UIViewController, AlertViewControllable {
    
    // MARK: - Properties
    
    public var customAction: (() -> Void)?
    public var cancelAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var backgroundDimmerView = CustomDimmerView(self)
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let cancelButton = UIButton()
    private let customButton = UIButton()
    private var alertType: AlertType!
    private var alertTheme: AlertTheme = .main
    
    // MARK: - Init
    
    public init(alertType: AlertType, alertTheme: AlertTheme = .main) {
        self.alertType = alertType
        self.alertTheme = alertTheme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout(alertType)
        setAddTarget()
    }
    
    // MARK: - Custom Method
    
    @discardableResult
    public func setTitle(_ title: String, _ description: String = "") -> Self {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        return self
    }
    
    @discardableResult
    public func setCustomButtonTitle(_ title: String) -> Self {
        self.customButton.setTitle(title, for: .normal)
        return self
    }
    
    private func setAddTarget() {
        self.cancelButton.addTarget(self, action: #selector(dismissCurrentVC), for: .touchUpInside)
        self.customButton.addTarget(self, action: #selector(tappedCustomButton), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissCurrentVC))
        self.backgroundDimmerView.addGestureRecognizer(gesture)
    }
    
    // MARK: - @objc
    
    @objc
    private func dismissCurrentVC() {
        self.dismiss(animated: true) {
            self.cancelAction?()
        }
    }
    
    @objc
    private func tappedCustomButton() {
        self.dismiss(animated: true) {
            self.customAction?()
        }
    }
}

// MARK: - UI & Layout

extension AlertVC {
    private func setUI() {
        self.view.backgroundColor = .clear
        self.alertView.backgroundColor = alertTheme.backgroundColor
        self.cancelButton.backgroundColor = alertTheme.cancelButtonColor(isSingleButtonAlert: self.alertType == .networkErr || self.alertType == .titleDescriptionSingleButton)
        self.customButton.backgroundColor = alertTheme.customButtonColor
        
        self.titleLabel.font = .Main.headline2
        self.descriptionLabel.font = .Main.body2
        self.cancelButton.titleLabel?.font = .Main.caption3
        self.customButton.titleLabel?.font = .Main.caption3
        
        self.titleLabel.textColor = alertTheme.titleColor
        self.descriptionLabel.textColor = alertTheme.descriptionColor
        self.cancelButton.setTitleColor(alertTheme.cancelButtonTitleColor(isSingleButtonAlert: self.alertType == .networkErr || self.alertType == .titleDescriptionSingleButton),
                                        for: .normal)
        self.customButton.setTitleColor(alertTheme.customButtonTitleColor, for: .normal)
        
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.numberOfLines = 0

        let cancelTitle: String
        switch self.alertType {
        case .networkErr, .titleDescriptionSingleButton:
            cancelTitle = I18N.Default.ok
        default:
            cancelTitle = I18N.Default.cancel
        }
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        
        self.alertView.layer.cornerRadius = 10
        self.alertView.layer.masksToBounds = true
        
        self.cancelButton.layer.cornerRadius = 10
        self.customButton.layer.cornerRadius = 10
    }
    
    
    
    private func setLayout(_ type: AlertType) {
        self.view.addSubviews(backgroundDimmerView, alertView)
        
        backgroundDimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
            // 고정 height 비율 제거 - 내부 콘텐츠에 따라 자동으로 늘어남
        }
        
        alertView.addSubview(titleLabel)
        
        let titleTopInset: CGFloat = (type == .title) ? 32 : 28
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(titleTopInset)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        var lastLabel = titleLabel
        
        if type != .title {
            alertView.addSubview(descriptionLabel)
            
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)  
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(20)
            }
            lastLabel = descriptionLabel
        }
        
        self.setButtonLayout(type, lastLabel: lastLabel)
    }

    private func setButtonLayout(_ type: AlertType, lastLabel: UILabel) {
        alertView.addSubviews(cancelButton)
        let buttonTopSpacing: CGFloat = 24
        
        switch type {
        case .title, .titleDescription:
            alertView.addSubviews(customButton)
            let buttonSpacing: Float = 7
            
            cancelButton.snp.makeConstraints { make in
                make.top.equalTo(lastLabel.snp.bottom).offset(buttonTopSpacing)
                make.leading.bottom.equalToSuperview().inset(buttonSpacing)
                make.width.equalTo(customButton.snp.width)
                make.height.equalTo(38)
            }
            
            customButton.snp.makeConstraints { make in
                make.trailing.bottom.equalToSuperview().inset(buttonSpacing)
                make.leading.equalTo(cancelButton.snp.trailing).offset(buttonSpacing)
                make.height.equalTo(cancelButton.snp.height)
            }

        case .titleDescriptionSingleButton, .networkErr:
            cancelButton.snp.makeConstraints { make in
                make.top.equalTo(lastLabel.snp.bottom).offset(buttonTopSpacing)
                make.leading.trailing.bottom.equalToSuperview().inset(7)
                make.height.equalTo(38)
            }
        }
    }
}
