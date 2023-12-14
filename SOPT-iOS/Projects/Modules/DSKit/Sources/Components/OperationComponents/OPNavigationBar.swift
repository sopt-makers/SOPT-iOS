//
//  OPNavigationBar.swift
//  DSKit
//
//  Created by devxsby on 2023/04/12.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import SnapKit

import Core

@frozen
public enum OPNaviType {
    case oneLeftButton /// 좌측 뒤로가기 버튼
    case oneRightButton /// 우측 버튼
    case bothButtons /// 좌측 뒤로가기, 우측 버튼
}

public final class OPNavigationBar: UIView {
    
    // MARK: - Properties
    
    private weak var vc: UIViewController?
    private var rightButtonClosure: (() -> Void)?
    public var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    public var leftButtonTapped: Driver<Void> {
        leftButton.publisher(for: .touchUpInside)
            .mapVoid()
            .asDriver()
    }
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)

    // MARK: - initialization
    
    public init(_ vc: UIViewController, type: OPNaviType, backgroundColor: UIColor = DSKitAsset.Colors.black100.color, ignoreLeftButtonAction: Bool = false) {
        super.init(frame: .zero)
        self.vc = vc
        self.setUI(type, backgroundColor: backgroundColor)
        self.setLayout(type)
        guard !ignoreLeftButtonAction else { return }
        self.setLeftBackButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension OPNavigationBar {
    
    private func setLeftBackButtonAction() {
        self.leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
    }
    
    @discardableResult
    public func addMiddleLabel(title: String?, font: UIFont = UIFont.Main.body1) -> Self {
        self.titleLabel.text = title
        self.titleLabel.font = font
        self.titleLabel.textColor = .white
        return self
    }
    
    @discardableResult
    public func addRightButton(with title: String?, titleColor: UIColor? = UIColor.white) -> Self {
        self.rightButton.setTitle(title, for: .normal)
        self.rightButton.titleLabel?.font = UIFont.Main.body1
        self.rightButton.setTitleColor(titleColor, for: .normal)
        return self
    }

    @discardableResult
    public func addRightButton(with image: UIImage?) -> Self {
        self.rightButton.setImage(image, for: .normal)
        return self
    }
    
    @discardableResult
    public func addRightButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.rightButtonClosure = closure
        self.rightButton.addTarget(self, action: #selector(touchupRightButton), for: .touchUpInside)
        return self
    }
    
    @discardableResult
    public func hideRightButton(wantsToHide: Bool) -> Self {
        self.rightButton.isHidden = wantsToHide
        return self
    }
}

// MARK: - @objc Function

extension OPNavigationBar {
    
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

extension OPNavigationBar {
    
    private func setUI(_ type: OPNaviType, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        
        switch type {
        case .oneLeftButton:
            leftButton.setImage(UIImage(asset: DSKitAsset.Assets.opArrowWhite), for: .normal)
        case .oneRightButton:
            rightButton.setImage(UIImage(asset: DSKitAsset.Assets.xMark)?.withTintColor(.white), for: .normal)
        case .bothButtons:
            leftButton.setImage(UIImage(asset: DSKitAsset.Assets.opArrowWhite), for: .normal)
            rightButton.setImage(UIImage(asset: DSKitAsset.Assets.opRefresh), for: .normal)
        }
    }
    
    private func setLayout(_ type: OPNaviType) {
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        switch type {
        case .oneLeftButton:
            self.setOneLeftButtonLayout()
        case .oneRightButton:
            self.setOneRightButtonLayout()
        case .bothButtons:
            self.setOneLeftButtonWithOneRightButtonLayout()
        }
    }
    
    private func setOneLeftButtonLayout() {
        self.addSubviews(titleLabel, leftButton)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setOneRightButtonLayout() {
        self.addSubviews(titleLabel, rightButton)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setOneLeftButtonWithOneRightButtonLayout() {
        self.addSubviews(leftButton, rightButton, titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
