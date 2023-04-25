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
public enum NaviType {
    case title /// 좌측 타이틀 + 우측 버튼 (미션 리스트 뷰)
    case titleWithLeftButton /// 좌측 뒤로가기 버튼 + 좌측 타이틀 (랭킹, 글 작성 등)
}

@frozen
public enum RightButtonType {
    case none
    case addRecord
    case delete
}

public class STNavigationBar: UIView {
    
    // MARK: - UI Component
    
    private var vc: UIViewController?
    private let titleLabel = UILabel()
    private let titleButton = UIButton()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    
    // MARK: - Properties
    
    private var naviType: NaviType!
    private var rightButtonClosure: (() -> Void)?
    private var leftButtonClosure: (() -> Void)?
    public var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    public var leftButtonTapped: Driver<Void> {
        leftButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    public var titleButtonTapped: Driver<Void> {
        titleButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    
    // MARK: - Initialize
    
    public init(_ vc: UIViewController, type: NaviType) {
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

extension STNavigationBar {
    public func hideNaviBar(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseInOut) {
            [self.titleLabel, self.leftButton, self.rightButton].forEach { $0.alpha = isHidden ? 0 : 1 }
        }
    }
    
    public func hideRightButton(_ isHidden: Bool = true) {
        self.rightButton.isHidden = isHidden
    }
    
    private func setAddTarget() {
        self.leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
    }
    
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        switch self.naviType {
        case .title:
            self.titleButton.setAttributedTitle(title.zeroKernString(), for: .normal)
        default:
            self.titleLabel.attributedText = title.zeroKernString()
        }
        return self
    }
    
    @discardableResult
    public func setRightButtonTitle(_ title: String) -> Self {
        self.rightButton.setAttributedTitle(title.zeroKernString(), for: .normal)
        return self
    }
    
    @discardableResult
    public func setRightButton(_ type: RightButtonType) -> Self {
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
        self.rightButton.addTarget(self, action: #selector(tappedRightButton), for: .touchUpInside)
        return self
    }
    
    @discardableResult
    public func resetLeftButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.leftButtonClosure = closure
        self.leftButton.removeTarget(self, action: nil, for: .touchUpInside)
        if closure != nil {
            self.leftButton.addTarget(self, action: #selector(tappedLeftButton), for: .touchUpInside)
        } else {
            self.setAddTarget()
        }
        return self
    }
    
    @discardableResult
    public func setTitleTypoStyle(_ font: UIFont) -> Self {
        titleButton.titleLabel?.setTypoStyle(font)
        titleLabel.setTypoStyle(font)
        return self
    }
    
    @discardableResult
    public func setTitleButtonMenu(menuItems: [UIAction]) -> Self {
        titleButton.menu = UIMenu(title: "",
                                  image: nil,
                                  identifier: nil,
                                  options: [.displayInline],
                                  children: menuItems)
        titleButton.showsMenuAsPrimaryAction = true
        return self
    }
    
    @discardableResult
    public func addLeftButtonToTitleMenu() -> Self {
        leftButton.setImage(DSKitAsset.Assets.icClose.image, for: .normal)
        leftButtonLayoutForMenu()
        return self
    }
    
    private func leftButtonLayoutForMenu() {
        self.addSubview(leftButton)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(1)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }
        
        titleButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview().offset(1)
            make.leading.equalTo(leftButton.snp.trailing).offset(12)
        }
    }
}

// MARK: - @objc

extension STNavigationBar {
    @objc
    private func popToPreviousVC() {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tappedRightButton() {
        self.rightButtonClosure?()
    }
    
    @objc
    private func tappedLeftButton() {
        self.leftButtonClosure?()
    }
}

// MARK: - UI & Layout

extension STNavigationBar {
    private func setUI(_ type: NaviType) {
        self.naviType = type
        
        self.backgroundColor = .white
        leftButton.setImage(UIImage(asset: DSKitAsset.Assets.icArrow), for: .normal)
        
        titleLabel.setTypoStyle(.SoptampFont.h2)
        titleLabel.textColor = DSKitAsset.Colors.soptampBlack.color
        
        switch type {
        case .title:
            rightButton.isHidden = false
            rightButton.setImage(DSKitAsset.Assets.stampGuide.image, for: .normal)
            titleButton.setImage(DSKitAsset.Assets.icDownArrow.image, for: .normal)
            titleButton.setTitleColor(.black, for: .normal)
            titleButton.semanticContentAttribute = .forceRightToLeft
            titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        case .titleWithLeftButton:
            rightButton.isHidden = true
            leftButton.setImage(UIImage(asset: DSKitAsset.Assets.icArrow), for: .normal)
            rightButton.setImage(UIImage(asset: DSKitAsset.Assets.icAddRecord), for: .normal)
        }
    }
    
    private func setLayout(_ type: NaviType) {
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
        self.addSubviews(titleButton, rightButton)
        
        titleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(1)
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
            make.centerY.equalToSuperview().offset(1)
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
