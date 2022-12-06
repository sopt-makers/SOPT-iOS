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

public class AlertVC: UIViewController {
    
    // MARK: - Properties
    
    public var customAction: (() -> Void)?
    
    // MARK: - UI Components
    
    private let blurEffect = UIBlurEffect(style: .dark)
    private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton()
    private let customButton = UIButton()
    
    // MARK: - View Life Cycles

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
    
    // MARK: - Custom Method
    
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.titleLabel.text = title
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
        self.visualEffectView.addGestureRecognizer(gesture)
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
        self.view.backgroundColor = .black.withAlphaComponent(0.6)
        self.alertView.backgroundColor = .white
        self.cancelButton.backgroundColor = DSKitAsset.Colors.gray300.color
        self.customButton.backgroundColor = DSKitAsset.Colors.error200.color
        
        self.titleLabel.setTypoStyle(.subtitle1)
        self.cancelButton.titleLabel?.setTypoStyle(.subtitle1)
        self.customButton.titleLabel?.setTypoStyle(.subtitle1)
        
        self.titleLabel.textColor = DSKitAsset.Colors.gray900.color
        self.cancelButton.titleLabel?.textColor = DSKitAsset.Colors.gray700.color
        self.customButton.titleLabel?.textColor = DSKitAsset.Colors.white.color
        
        self.cancelButton.setTitle(I18N.Default.cancel, for: .normal)
        
        self.alertView.layer.cornerRadius = 10
        self.alertView.layer.masksToBounds = true
    }
    
    private func setLayout() {
        self.view.addSubviews(visualEffectView, alertView)
        
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(alertView.snp.width).multipliedBy(0.49)
        }
        
        alertView.addSubviews(titleLabel, cancelButton, customButton)
        
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
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-22)
        }
    }
}
