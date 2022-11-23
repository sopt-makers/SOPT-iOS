//
//  CustomTextFieldView.swift
//  PresentationTests
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit
import Then

import Core
import DSKit

@frozen
enum TextFieldViewType {
    case plain
    case subTitle
    case titleWithRightButton
    
    var height: Float {
        switch self {
        case .plain:
            return 48
        case .subTitle:
            return 60
        case .titleWithRightButton:
            return 83
        }
    }
}

@frozen
enum TextFieldType {
    case email
    case password
    case none
}

@frozen
enum TextFieldViewState {
    case normal
    case editing
    case alert
    
    var backgroundColor: UIColor {
        switch self {
        case .normal:
            return DSKitAsset.Colors.gray50.color
        case .editing:
            return DSKitAsset.Colors.white.color
        case .alert:
            return DSKitAsset.Colors.error100.color
        }
    }
    
    var borderColor: CGColor? {
        switch self {
        case .normal:
            return nil
        case .editing:
            return DSKitAsset.Colors.purple300.color.cgColor
        case .alert:
            return DSKitAsset.Colors.error200.color.cgColor
        }
    }
}

class CustomTextFieldView: UIView {
    
    // MARK: - Properties
    
    private typealias SoptampColor = DSKitAsset.Colors
    
    private var type: TextFieldViewType!
    
    public var rightButtonTapped: Driver<Void> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in () }
            .asDriver()
    }
    
    public var textChanged: Driver<String?> {
        textField.publisher(for: .editingChanged)
            .map { _ in
                self.textField.text
            }
            .asDriver()
    }
    
    private var cancelBag = CancelBag()

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
        self.type = type
        self.setUI()
        self.setLayout(type)
        self.setDelegate()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomTextFieldView {
    @discardableResult
    func setTitle(_ titleText: String) -> Self {
        self.titleLabel.text = titleText
        return self
    }
    
    @discardableResult
    func setSubTitle(_ subTitleText: String) -> Self {
        self.subTitleLabel.text = subTitleText
        return self
    }
    
    @discardableResult
    func setPlaceholder(_ placeholderText: String) -> Self {
        self.textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
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
        case .none:
            break
        }
        return self
    }
    
    @discardableResult
    func setAlertLabelEnabled() -> Self {
        self.snp.updateConstraints { make in
            make.height.equalTo(self.type.height + 26)
        }
        
        self.addSubview(alertlabel)
        alertlabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainerView.snp.bottom).offset(12)
            make.leading.equalToSuperview()
        }
        return self
    }
    
    @discardableResult
    func setAlertLabel(_ alertText: String) -> Self {
        self.alertlabel.text = alertText
        return self
    }
    
    private func setDelegate() {
        self.textField.delegate = self
    }
    
    func setTextFieldViewState(_ state: TextFieldViewState) {
        textFieldContainerView.backgroundColor = state.backgroundColor
        
        if let borderColor = state.borderColor {
            textFieldContainerView.layer.borderWidth = 1
            textFieldContainerView.layer.borderColor = borderColor
        } else {
            textFieldContainerView.layer.borderWidth = 0
        }
    }
    
    private func bindUI() {
        textChanged
            .replaceNil(with: "")
            .sink { text in
                self.rightButton.isEnabled = !text.isEmpty
                if text.isEmpty {
                    self.setAlertLabel("")
                }
            }.store(in: cancelBag)
    }
}

// MARK: - UI & Layout

extension CustomTextFieldView {
    private func setUI() {
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
        rightButton.isEnabled = false
        
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
            make.height.equalTo(self.type.height)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(type.height)
        }
        
        textFieldContainerView.addSubviews(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setSubTitleLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.type.height)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(type.height)
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
            make.height.equalTo(self.type.height)
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

// MARK: - UITextFieldDelegate

extension CustomTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setTextFieldViewState(.editing)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setTextFieldViewState(.normal)
    }
}
