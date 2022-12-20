//
//  CustomTextFieldView.swift
//  DSKit
//
//  Created by sejin on 2022/11/23.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit
import Combine

import SnapKit
import Then

import Core

@frozen
public enum TextFieldViewType {
    case plain
    case subTitle
    case title
    case titleWithRightButton
    
    var height: Float {
        switch self {
        case .plain:
            return 48
        case .subTitle:
            return 60
        case .title, .titleWithRightButton:
            return 83
        }
    }
}

@frozen
public enum TextFieldType {
    case email
    case password
    case none
}

@frozen
public enum TextFieldViewState {
    case normal
    case editing
    case warningAlert
    case confirmAlert
    
    var backgroundColor: UIColor {
        switch self {
        case .normal:
            return DSKitAsset.Colors.gray50.color
        case .editing, .confirmAlert:
            return DSKitAsset.Colors.white.color
        case .warningAlert:
            return DSKitAsset.Colors.error100.color
        }
    }
    
    var borderColor: CGColor? {
        switch self {
        case .normal:
            return nil
        case .editing, .confirmAlert:
            return DSKitAsset.Colors.purple300.color.cgColor
        case .warningAlert:
            return DSKitAsset.Colors.error200.color.cgColor
        }
    }
    
    var alertTextColor: UIColor? {
        switch self {
        case .normal, .editing:
            return nil
        case .confirmAlert:
            return DSKitAsset.Colors.access300.color
        case .warningAlert:
            return DSKitAsset.Colors.error300.color
        }
    }
}

@frozen
public enum TextFieldAlertType {
    case validInput(text: String)
    case invalidInput(text: String)
    case none
    
    public var alertText: String {
        switch self {
        case .validInput(let text), .invalidInput(let text):
            return text
        case .none:
            return ""
        }
    }
    
    public var textFieldSate: TextFieldViewState {
        switch self {
        case .validInput:
            return .confirmAlert
        case .invalidInput:
            return .warningAlert
        case .none:
            return .normal
        }
    }
}

public protocol CustomTextFieldViewAlertDelegate: AnyObject {
    func changeAlertLabelText(_ alertText: String)
}

public class CustomTextFieldView: UIView {
    
    // MARK: - Properties
    
    private typealias SoptampColor = DSKitAsset.Colors
    
    private var type: TextFieldViewType!
    
    public var rightButtonTapped: Driver<String?> {
        rightButton.publisher(for: .touchUpInside)
            .map { _ in
                self.textField.text
            }
            .asDriver()
    }
    
    public var textChanged: Driver<String?> {
        textField.publisher(for: .editingChanged)
            .map { _ in
                self.textField.text
            }
            .asDriver()
    }
    
    public var alertType: TextFieldAlertType = .none {
        didSet {
            bindAlertType(alertType)
        }
    }
    
    public var maxLength: Int?
    
    public var text: String {
        self.textField.text ?? ""
    }
    
    /// alert Label을 다른 CustomTextField에 보여주기 위한 delegate
    weak var alertDelegate: CustomTextFieldViewAlertDelegate?
    
    private var cancelBag = CancelBag()

    // MARK: - UI Component
    
    private let titleLabel = UILabel()
    private let textFieldContainerView = UIView()
    private let subTitleLabel = UILabel()
    private let textField = UITextField()
    private let rightButton = UIButton()
    private let alertlabel = UILabel()

    // MARK: - Initialize
    
    public init(type: TextFieldViewType) {
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
    /// 버튼의 타이틀 변경
    @discardableResult
    public func setTitle(_ titleText: String) -> Self {
        self.titleLabel.text = titleText
        return self
    }
    
    /// textContainerView 내부의 subTitle text 변경
    @discardableResult
    public func setSubTitle(_ subTitleText: String) -> Self {
        self.subTitleLabel.text = subTitleText
        return self
    }
    
    /// placeholder text 변경
    @discardableResult
    public func setPlaceholder(_ placeholderText: String) -> Self {
        self.textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: SoptampColor.gray600.color,
                .font: UIFont.caption1
            ]
        )
        return self
    }
    
    /// cornerRadius 설정
    @discardableResult
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        self.textFieldContainerView.layer.cornerRadius = radius
        self.rightButton.layer.cornerRadius = radius
        return self
    }
    
    /// TextFieldType에 맞는 키보드, 텍스트 필드 보안 처리 (이메일, 비밀번호 등)
    @discardableResult
    public func setTextFieldType(_ type: TextFieldType) -> Self {
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
    
    /// 하단에 경고 문구 라벨 생성
    @discardableResult
    public func setAlertLabelEnabled(_ alertText: String) -> Self {
        self.snp.updateConstraints { make in
            make.height.equalTo(self.type.height + 26)
        }
        
        self.addSubview(alertlabel)
        alertlabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldContainerView.snp.bottom).offset(12)
            make.leading.equalToSuperview()
        }
        
        alertlabel.text = alertText
        return self
    }
    
    @discardableResult
    public func setMaxLength(_ length: Int) -> Self {
        self.maxLength = length
        return self
    }
    
    /// alertText를 다른 TextField에 보여주기 위한 delegate 설정
    public func setAlertDelegate(_ textView: CustomTextFieldViewAlertDelegate) -> Self {
        self.alertDelegate = textView
        return self
    }
    
    /// 경고 문구 라벨의 text 설정
    public func changeAlertLabelText(_ alertText: String) {
        if let alertDelegate = alertDelegate {
            alertDelegate.changeAlertLabelText(alertText)
            return
        }
        self.alertlabel.text = alertText
        self.alertlabel.isHidden = false
    }
    
    /// textField의 state를 지정하여 자동으로 배경색과 테두리 색이 바뀌도록 설정
    public func setTextFieldViewState(_ state: TextFieldViewState) {
        textFieldContainerView.backgroundColor = state.backgroundColor
        
        if let borderColor = state.borderColor {
            textFieldContainerView.layer.borderWidth = 1
            textFieldContainerView.layer.borderColor = borderColor
        } else {
            textFieldContainerView.layer.borderWidth = 0
        }
        
        if state == .confirmAlert || state == .warningAlert {
            alertlabel.textColor = state.alertTextColor
        }
    }
    
    private func setDelegate() {
        self.textField.delegate = self
    }
    
    private func bindUI() {
        textChanged
            .replaceNil(with: "")
            .sink { text in
                if let maxLength = self.maxLength, text.count > maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    self.textField.text = String(newString)
                }
                
                self.rightButton.isEnabled = !text.isEmpty
                if text.isEmpty {
                    self.changeAlertLabelText("")
                }
            }.store(in: cancelBag)
    }
}

// MARK: - Input Binding

extension CustomTextFieldView {
    
    var alertText: String {
        return alertlabel.text ?? ""
    }
    
    private func bindAlertType(_ alertType: TextFieldAlertType) {
        self.changeAlertLabelText(alertType.alertText)
        self.setTextFieldViewState(alertType.textFieldSate)
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
        textField.returnKeyType = .done
        
        alertlabel.font = UIFont.caption3
        alertlabel.textColor = SoptampColor.error300.color
        alertlabel.isHidden = true
        
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
        case .title:
            self.setTitleLayout()
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
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        setCornerRadius(10)
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
        
        setCornerRadius(12)
    }
    
    private func setTitleLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.type.height)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        textFieldContainerView.addSubviews(textField)
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        setCornerRadius(10)
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
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        setCornerRadius(10)
    }
}

// MARK: - UITextFieldDelegate

extension CustomTextFieldView: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setTextFieldViewState(.editing)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEmpty {
            self.setTextFieldViewState(.normal)
        } else {
            if case .invalidInput = alertType {
                return
            }
            self.setTextFieldViewState(.editing)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - CustomTextFieldViewAlertDelegate

extension CustomTextFieldView: CustomTextFieldViewAlertDelegate {
    /// 경고 문구 라벨의 컬러 설정
    public func changeAlertLabelTextColor(toWarning: Bool) {
        alertlabel.textColor = toWarning ? SoptampColor.error300.color : SoptampColor.access300.color
    }
}
