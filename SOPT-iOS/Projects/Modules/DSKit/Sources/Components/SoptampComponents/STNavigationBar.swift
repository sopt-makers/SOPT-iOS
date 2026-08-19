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
import MDS

@frozen
public enum NaviType: Equatable {
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
    
    private let titleLabel = UILabel()
    private let titleButton = UIButton()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let reportButton = UIButton()
    
    // MARK: - Properties
    
    private var naviType: NaviType!
    private var rightButtonClosure: (() -> Void)?
    private var leftButtonClosure: (() -> Void)?
    private var reportButtonClosure: (() -> Void)?
    
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
    public var reportButtonTapped: Driver<Void> {
        reportButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    
    // MARK: - Initialize
    
    public init(type: NaviType) {
        super.init(frame: .zero)
        self.setUI(type)
        self.setLayout(type)
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
    
    private func setAddTarget(_ ignorePopAction: Bool = false) {
        guard !ignorePopAction else { return }
//        self.leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
    }
    
    private func leftButtonLayoutForMenu() {
        self.addSubview(leftButton)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        titleButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftButton.snp.trailing).offset(10)
        }
    }
}

extension STNavigationBar {
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        switch self.naviType {
        case .title:
            let attributes = Typography.title4.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.bold)
            self.titleButton.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        default:
            self.titleLabel.text = title
            self.titleLabel.setTypography(Typography.title4,
                                          textColor: SemanticColor.Fg.Neutral.bold)
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
            self.rightButton.setImage(MDSIcon.drawOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
        case .delete:
            self.rightButton.isHidden = false
            self.rightButton.setImage(MDSIcon.xCloseOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
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
    public func reportButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.reportButtonClosure = closure
        self.reportButton.addTarget(self, action: #selector(tappedReportButton), for: .touchUpInside)
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
    
    @discardableResult
    public func setLeftButtonHidden(_ isHidden: Bool) -> Self {
        guard naviType == .title else { return self }
        
        if !isHidden {
            addSubview(leftButton)
        } else {
            leftButton.removeFromSuperview()
        }
    
        titleButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview().offset(1)
            
            if isHidden {
                make.leading.equalToSuperview().offset(20)
            } else {
                make.leading.equalTo(leftButton.snp.trailing).offset(10)
            }
        }
    
        return self
    }
}

// MARK: - @objc

extension STNavigationBar {
    @objc
    private func tappedRightButton() {
        self.rightButtonClosure?()
    }
    
    @objc
    private func tappedLeftButton() {
        self.leftButtonClosure?()
    }
    
    @objc
    private func tappedReportButton() {
        self.reportButtonClosure?()
    }
}

// MARK: - UI & Layout

extension STNavigationBar {
    private func setUI(_ type: NaviType) {
        self.naviType = type
        
        self.backgroundColor = SemanticColor.Bg.Layer.basement
        leftButton.setImage(MDSIcon.chevronLeftOutlined.image, for: .normal)

        switch type {
        case .title:
            rightButton.isHidden = false
            // TODO: 디자인 문의
            rightButton.setImage(DSKitAsset.Assets.icCommunicationEdit.image, for: .normal)
            titleButton.setImage(MDSIcon.chevronDownOutlined.image, for: .normal)
            titleButton.semanticContentAttribute = .forceRightToLeft
            titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
            reportButton.setImage(MDSIcon.alertTriangleOutlined.image, for: .normal)
        case .titleWithLeftButton:
            rightButton.isHidden = true
            leftButton.setImage(MDSIcon.chevronLeftOutlined.image, for: .normal)
            rightButton.setImage(MDSIcon.drawOutlined.image.withTintColor(SemanticColor.Fg.Neutral.bold), for: .normal)
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
        self.addSubviews(titleButton, rightButton, reportButton)
        
        titleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }

        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }
        
        reportButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rightButton.snp.leading).offset(-12)
            make.size.equalTo(32)
        }
        
    }
    
    private func setTitleWithLeftButton() {
        self.addSubviews(leftButton, titleLabel, rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(1)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(leftButton.snp.trailing).offset(6)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
    }
}
