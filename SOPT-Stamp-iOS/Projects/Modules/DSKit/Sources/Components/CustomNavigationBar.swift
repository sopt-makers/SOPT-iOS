//
//  CustomNavigationBar.swift
//  Presentation
//
//  Created by 양수빈 on 2022/10/20.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core
import DSKit

@frozen
enum naviType {
    case leftTitle
    case leftTitleWithLeftButton
    case onlyRightButton
}

class CustomNavigationBar: UIView {
    
    // MARK: - UI Component
    
    private var vc: UIViewController?
    private let titleLabel = UILabel()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let otherRightButton = UIButton()
    
    // MARK: - Properties
    
    private var rightButtonClosure: (() -> Void)?
    private var otherRightButtonClosure: (() -> Void)?
    public var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    
    // MARK: - Initialize
    
    init(_ vc: UIViewController, type: naviType) {
        super.init(frame: .zero)
        self.vc = vc
        self.setUI(type)
        self.setLayout(type)
        self.setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method

extension CustomNavigationBar {
    func hideNaviBar(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseInOut) {
            [self.titleLabel, self.leftButton, self.rightButton, self.otherRightButton].forEach { $0.alpha = isHidden ? 0 : 1 }
        }
    }
    
    private func setAddTarget() {
        self.leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
    }
    
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
    
    @discardableResult
    func setRightButtonTitle(_ title: String) -> Self {
        self.rightButton.setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    func rightButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.rightButtonClosure = closure
        self.rightButton.addTarget(self, action: #selector(touchupRightButton), for: .touchUpInside)
        return self
    }
    
    @discardableResult
    func otherRightButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.otherRightButtonClosure = closure
        self.otherRightButton.addTarget(self, action: #selector(touchupOtherRightButton), for: .touchUpInside)
        return self
    }
}

// MARK: - @objc

extension CustomNavigationBar {
    @objc
    private func popToPreviousVC() {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func touchupRightButton() {
        self.rightButtonClosure?()
    }
    
    @objc
    private func touchupOtherRightButton() {
        self.otherRightButtonClosure?()
    }
}

// MARK: - UI & Layout

extension CustomNavigationBar {
    private func setUI(_ type: naviType) {
//        leftButton.setImage(UIImage(asset: DSKitAsset.Assets.icBack), for: .normal)
//        
//        titleLabel.setTypoStyle(.h5)
//        titleLabel.textColor = DSKitAsset.Colors.gray900.color
//        
//        switch type {
//        case .leftTitle:
//            rightButton.setImage(UIImage(asset: DSKitAsset.Assets.icSetting), for: .normal)
//            otherRightButton.setImage(UIImage(asset: DSKitAsset.Assets.icSearch), for: .normal)
//        case .leftTitleWithLeftButton, .onlyRightButton:
//            rightButton.setTitleColor(DSKitAsset.Colors.blue500.color, for: .normal)
//            rightButton.titleLabel?.setTypoStyle(.body1)
//        }
    }
    
    private func setLayout(_ type: naviType) {
        self.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        switch type {
        case .leftTitle:
            self.setLeftTitleLayout()
        case .leftTitleWithLeftButton:
            self.setLeftTitleWithButtonLayout()
            self.setRightButtonLayout()
        case .onlyRightButton:
            self.setRightButtonLayout()
        }
    }
    
    private func setLeftTitleLayout() {
        self.addSubviews(titleLabel, rightButton, otherRightButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(40)
        }
        
        otherRightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightButton.snp.leading)
            make.width.height.equalTo(40)
        }
    }
    
    private func setLeftTitleWithButtonLayout() {
        self.addSubviews(leftButton, titleLabel)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftButton.snp.trailing)
        }
    }
    
    private func setRightButtonLayout() {
        self.addSubviews(rightButton)
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
}
