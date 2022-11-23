//
//  CustomTextFieldView.swift
//  PresentationTests
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import SnapKit
import Then

import Core
import DSKit

@frozen
enum TextFieldViewType {
    case plain
    case subTitle
    case titleWithRightButton
}

@frozen
enum TextFieldType {
    case email
    case password
}

class CustomTextFieldView: UIView {
    
    // MARK: - Properties
    private typealias SoptampColor = DSKitAsset.Colors
    
    public var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    
    // MARK: - UI Component
    
    private let titleLabel = UILabel()
    private let textFieldContainerView = UIView()
    private let subTitleLabel = UILabel()
    private let textField = UITextField()
    private let rightButton = UIButton()
    private let alertlabel = UILabel()

    // MARK: - Initialize
    
    init(type: TextFieldViewType) {
        super.init(frame: .zero)
        self.setUI(type)
        self.setLayout(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI & Layout

extension CustomTextFieldView {
    @discardableResult
    func setTitle(_ title: String) -> Self {
        self.titleLabel.text = title
        return self
    }
    
    @discardableResult
    func setSubTitle(_ subTitle: String) -> Self {
        self.subTitleLabel.text = subTitle
        return self
    }
    
    @discardableResult
    func setPlaceholder(_ placeholder: String) -> Self {
        self.textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: SoptampColor.gray600.color,
                .font: UIFont.caption1
            ]
        )
        return self
    }
    
    @discardableResult
    func setCornerRadius(_ radius: CGFloat) -> Self {
        self.textFieldContainerView.layer.cornerRadius = radius
        self.rightButton.layer.cornerRadius = radius
        return self
    }
    
    @discardableResult
    func setTextFieldType(_ type: TextFieldType) -> Self {
        switch type {
        case .email:
            self.textField.keyboardType = .emailAddress
        case .password:
            self.textField.isSecureTextEntry = true
        }
        return self
    }
}

// MARK: - UI & Layout

extension CustomTextFieldView {
    private func setUI(_ type: TextFieldViewType) {
        titleLabel.font = UIFont.subtitle1
        titleLabel.textColor = SoptampColor.gray900.color
        
        textFieldContainerView.backgroundColor = SoptampColor.gray50.color
        textFieldContainerView.clipsToBounds = true

        subTitleLabel.textAlignment = .left
        subTitleLabel.font = UIFont.id
        subTitleLabel.textColor = SoptampColor.gray400.color
        
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.font = UIFont.caption1
        
        alertlabel.font = UIFont.caption3
        alertlabel.textColor = SoptampColor.error300.color
        
        rightButton.clipsToBounds = true
        
        rightButton.setBackgroundColor(
            SoptampColor.purple200.color,
            for: .disabled
        )
        
        rightButton.setBackgroundColor(
            SoptampColor.purple300.color,
            for: .normal
        )
        
        rightButton.setAttributedTitle(
            NSAttributedString(string: I18N.TextFieldView.verify,
                               attributes: [.foregroundColor: SoptampColor.white.color, .font: UIFont.subtitle3]),
            for: .normal
        )
    }
    
    private func setLayout(_ type: TextFieldViewType) {
        self.addSubview(textFieldContainerView)
        switch type {
        case .plain:
            self.setPlainLayout()
        case .subTitle:
            self.setSubTitleLayout()
        case .titleWithRightButton:
            self.setTitleWithRightButtonLayout()
        }
    }
    
    private func setPlainLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textFieldContainerView.addSubviews(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setSubTitleLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textFieldContainerView.addSubviews(subTitleLabel, textField)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.leading.trailing.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(6)
            make.leading.bottom.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setTitleWithRightButtonLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(83)
        }
        
        self.addSubviews(titleLabel, rightButton)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.height.equalTo(48)
            make.trailing.equalTo(rightButton.snp.leading).inset(-4)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(textFieldContainerView)
            make.trailing.equalToSuperview()
            make.width.equalTo(60)
        }
        
        textFieldContainerView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
