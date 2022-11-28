//
//  CustomNavigationBar.swift
//  DSKit
//
//  Created by 양수빈 on 2022/10/20.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core

@frozen
public enum naviType {
    case title /// 좌측 타이틀 + 우측 버튼 (미션 리스트 뷰)
    case titleWithLeftButton /// 좌측 뒤로가기 버튼 + 좌측 타이틀 (랭킹, 글 작성 등)
}

@frozen
public enum rightButtonType {
    case none
    case addRecord
    case delete
}

public class CustomNavigationBar: UIView {
    
    // MARK: - UI Component
    
    private var vc: UIViewController?
    private let titleLabel = UILabel()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    
    // MARK: - Properties
    
    private var rightButtonClosure: (() -> Void)?
    public var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    
    // MARK: - Initialize
    
    public init(_ vc: UIViewController, type: naviType) {
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
    public func hideNaviBar(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseInOut) {
            [self.titleLabel, self.leftButton, self.rightButton].forEach { $0.alpha = isHidden ? 0 : 1 }
        }
    }
    
    private func setAddTarget() {
        self.leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
    }
    
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
    
    @discardableResult
    public func setRightButtonTitle(_ title: String) -> Self {
        self.rightButton.setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    public func setRightButton(_ type: rightButtonType) -> Self {
        switch type {
        case .none:
            self.rightButton.isHidden = true
        case .addRecord:
            self.rightButton.isHidden = false
            self.rightButton.setImage(UIImage(asset: DSKitAsset.Assets.icAddRecord), for: .normal)
        case .delete:
            self.rightButton.isHidden = false
            self.rightButton.setImage(UIImage(asset: DSKitAsset.Assets.icDelete), for: .normal)
        }
        return self
    }
    
    @discardableResult
    public func rightButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.rightButtonClosure = closure
        self.rightButton.addTarget(self, action: #selector(touchupRightButton), for: .touchUpInside)
        return self
    }
    
    @discardableResult
    public func setTitleTypoStyle(_ font: UIFont) -> Self {
        titleLabel.setTypoStyle(font)
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
}

// MARK: - UI & Layout

extension CustomNavigationBar {
    private func setUI(_ type: naviType) {
        leftButton.setImage(UIImage(asset: DSKitAsset.Assets.icArrow), for: .normal)
        
        titleLabel.setTypoStyle(.h2)
        titleLabel.textColor = DSKitAsset.Colors.black.color
        
        switch type {
        case .title:
            rightButton.isHidden = false
            rightButton.setImage(UIImage(asset: DSKitAsset.Assets.icAddRecord), for: .normal)
        case .titleWithLeftButton:
            rightButton.isHidden = true
            leftButton.setImage(UIImage(asset: DSKitAsset.Assets.icArrow), for: .normal)
            rightButton.setImage(UIImage(asset: DSKitAsset.Assets.icAddRecord), for: .normal)
        }
    }
    
    private func setLayout(_ type: naviType) {
        self.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        switch type {
        case .title:
            self.setTitleLayout()
        case .titleWithLeftButton:
            self.setTitleWithLeftButton()
        }
    }
    
    private func setTitleLayout() {
        self.addSubviews(titleLabel, rightButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }
    }
    
    private func setTitleWithLeftButton() {
        self.addSubviews(leftButton, titleLabel, rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftButton.snp.trailing).offset(2)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
    }
}
