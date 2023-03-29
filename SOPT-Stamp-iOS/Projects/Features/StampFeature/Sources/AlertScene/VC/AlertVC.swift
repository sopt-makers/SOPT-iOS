//
//  AlertVC.swift
//  Presentation
//
//  Created by 양수빈 on 2022/12/05.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core
import DSKit

import StampFeatureInterface

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
    
    // MARK: - Init
    
    public init(alertType: AlertType) {
        self.alertType = alertType
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
        self.alertView.backgroundColor = .white
        self.cancelButton.backgroundColor = (self.alertType == .networkErr) ? DSKitAsset.Colors.error200.color : DSKitAsset.Colors.gray300.color
        self.customButton.backgroundColor = DSKitAsset.Colors.error200.color
        
        self.titleLabel.setTypoStyle(.SoptampFont.subtitle1)
        self.descriptionLabel.setTypoStyle(.SoptampFont.caption3)
        self.cancelButton.titleLabel?.setTypoStyle(.SoptampFont.subtitle1)
        self.customButton.titleLabel?.setTypoStyle(.SoptampFont.subtitle1)
        
        self.titleLabel.textColor = DSKitAsset.Colors.gray900.color
        self.descriptionLabel.textColor = DSKitAsset.Colors.gray500.color
        self.cancelButton.titleLabel?.textColor = DSKitAsset.Colors.gray700.color
        self.customButton.titleLabel?.textColor = DSKitAsset.Colors.white.color
        
        self.descriptionLabel.textAlignment = .center
        self.descriptionLabel.numberOfLines = 2
        
        let cancelTitle = (self.alertType == .networkErr) ? I18N.Default.ok : I18N.Default.cancel
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        
        self.alertView.layer.cornerRadius = 10
        self.alertView.layer.masksToBounds = true
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
                make.leading.trailing.equalToSuperview().inset(30)
            }
        }
    }
    
    private func setButtonLayout(_ type: AlertType) {
        alertView.addSubviews(cancelButton)
        
        switch type {
        case .title, .titleDescription:
            alertView.addSubviews(customButton)
            
            cancelButton.snp.makeConstraints { make in
                make.leading.bottom.equalToSuperview()
                make.width.equalTo(alertView.snp.width).multipliedBy(0.5)
                make.height.equalTo(cancelButton.snp.width).multipliedBy(0.347)
            }
            
            customButton.snp.makeConstraints { make in
                make.trailing.bottom.equalToSuperview()
                make.leading.equalTo(cancelButton.snp.trailing)
                make.top.equalTo(cancelButton.snp.top)
            }
        case .networkErr:
            cancelButton.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.width.equalTo(alertView.snp.width)
                make.height.equalTo(cancelButton.snp.width).multipliedBy(0.17)
            }
        }
    }
}
