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
        self.dismiss(animated: true)
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
        self.cancelButton.backgroundColor = alertTheme.cancelButtonColor(isNetworkErr: self.alertType == .networkErr)
        self.customButton.backgroundColor = alertTheme.customButtonColor
        
        self.titleLabel.setTypoStyle(.Main.headline2)
        self.descriptionLabel.setTypoStyle(.Main.body2)
        self.cancelButton.titleLabel?.setTypoStyle(.Main.caption3)
        self.customButton.titleLabel?.setTypoStyle(.Main.caption3)
        
        self.titleLabel.textColor = alertTheme.titleColor
        self.descriptionLabel.textColor = alertTheme.descriptionColor
        self.cancelButton.setTitleColor(alertTheme.cancelButtonTitleColor(isNetworkErr: self.alertType == .networkErr),
                                        for: .normal)
        self.customButton.setTitleColor(alertTheme.customButtonTitleColor, for: .normal)
        
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.numberOfLines = 2
        
        let cancelTitle = (self.alertType == .networkErr) ? I18N.Default.ok : I18N.Default.cancel
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        
        self.alertView.layer.cornerRadius = 10
        self.alertView.layer.masksToBounds = true
        
        self.cancelButton.layer.cornerRadius = 10
        self.customButton.layer.cornerRadius = 10
    }
    
    private func setLayout(_ type: AlertType) {
        let heightRatio = (type == .title) ? 0.49 : 0.55
        let titleOffset = (type == .title) ? -22 : -35
        
        self.view.addSubviews(backgroundDimmerView, alertView)
        
        backgroundDimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(alertView.snp.width).multipliedBy(heightRatio)
        }
        
        self.setButtonLayout(type)
        
        alertView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(titleOffset)
        }
        
        if type != .title {
            alertView.addSubview(descriptionLabel)
            
            descriptionLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-6)
                make.leading.trailing.equalToSuperview().inset(7)
            }
        }
    }
    
    private func setButtonLayout(_ type: AlertType) {
        alertView.addSubviews(cancelButton)
        
        switch type {
        case .title, .titleDescription:
            alertView.addSubviews(customButton)
            let buttonSpacing: Float = 7
            
            cancelButton.snp.makeConstraints { make in
                make.leading.bottom.equalToSuperview().inset(buttonSpacing)
                make.width.equalTo(customButton.snp.width)
                make.height.equalTo(38)
            }
            
            customButton.snp.makeConstraints { make in
                make.trailing.bottom.equalToSuperview().inset(buttonSpacing)
                make.leading.equalTo(cancelButton.snp.trailing).offset(buttonSpacing)
                make.height.equalTo(cancelButton.snp.height)
            }
        case .networkErr:
            cancelButton.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview().inset(7)
                make.height.equalTo(38)
            }
        }
    }
}
