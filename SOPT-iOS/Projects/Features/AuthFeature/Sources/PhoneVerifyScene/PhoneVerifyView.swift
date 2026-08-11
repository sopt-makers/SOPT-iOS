//
//  SignUpPhoneVerifyView.swift
//  AuthFeature
//
//  Created by 장석우 on 1/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import MDS

final class PhoneVerifyView: UIView {

    private var isTimeLeftError = false

    public var helpViewHidden: Bool {
        get { helpCallout.isHidden }
        set { helpCallout.isHidden = newValue }
    }
    
    public var viewModelInput: PhoneVerifyViewModel.Input {
        return .init(
            sendButtonTapped: sendButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            doneButtonTapped: doneButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            phoneTextFieldText: phoneTextField.publisher(for: .editingChanged).compactMap { $0.text }.asDriver(),
            codeTextFieldText: codeTextField.publisher(for: .editingChanged).compactMap { $0.text }.asDriver()
        )
    }
    
    // TODO: 터치 영역 문의 필요 - MDSCallout이 내부 버튼에 외부 탭 클로저를 제공하지 않아 배너 전체 탭으로 유지, 추후 문의 후 수정
    public var loginHelpButtonTapped: Driver<Void> {
        helpCallout.gesture().mapVoid().asDriver()
    }
    
    private static let i18N = I18N.Auth.PhoneVerify.self
    
    private let titleLabel = UILabel().then {
        $0.text = i18N.title
        $0.setTypography(Typography.heading2, textColor: SemanticColor.Fg.Neutral.bold)
        $0.textAlignment = .center
    }

    private let descriptionLabel = UILabel().then {
        $0.text = i18N.description
        $0.setTypography(Typography.body3, textColor: SemanticColor.Fg.Neutral.subtle)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    private let phoneField = MDSTextField(
        variant: .default,
        placeholder: i18N.phonePlaceholder,
        label: i18N.phoneLabel,
        isRequired: true
    )

    // TODO: MDSTextField가 텍스트 변경 Combine publisher(예: textDidChangePublisher)를 공개 API로 노출해야함
    private lazy var phoneTextField: UITextField = {
        guard let textField = phoneField.firstSubview(ofType: UITextField.self) else {
            fatalError("phoneField 내부에서 UITextField를 찾을 수 없습니다.")
        }
        textField.keyboardType = .numberPad
        textField.addToolbar()
        return textField
    }()

    private let sendButton = UIButton().then {
        $0.layer.cornerRadius = BaseRadius.Base.r8
        $0.layer.masksToBounds = true
        $0.backgroundColor = SemanticColor.Bg.Neutral.inverse
    }

    private let codeField = MDSTextField(
        variant: .default,
        placeholder: i18N.codePlaceholder
    ).then {
        $0.isHidden = true
    }

    // TODO: MDSTextField가 textDidChangePublisher/keyboardType API를 노출하면 phoneTextField와 함께 대체
    private lazy var codeTextField: UITextField = {
        guard let textField = codeField.firstSubview(ofType: UITextField.self) else {
            fatalError("codeField 내부에서 UITextField를 찾을 수 없습니다.")
        }
        textField.keyboardType = .numberPad
        textField.addToolbar()
        textField.addRightPadding(width: 68)
        return textField
    }()

    private let timeLeftLabel = UILabel().then {
        $0.text = i18N.defaultTimerText
        $0.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.bold)
    }

    private let helpCallout = MDSCallout(
        style: .information,
        text: i18N.helpDescription,
        icon: .alertCircleOutlined,
        buttonTitle: i18N.inquireButtonTitle
    )

    private let doneButton = MDSActionButton(variant: .primary, size: .large, title: i18N.doneButtonTitle)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubviews(
            titleLabel,
            descriptionLabel,
            phoneField,
            sendButton,
            codeField,
            helpCallout,
            doneButton
        )

        codeTextField.addSubview(timeLeftLabel)

        setSendButtonTitle(Self.i18N.sendButtonTitle)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(BaseSpacing.Base.s8)
            $0.centerX.equalToSuperview()
        }

        sendButton.snp.makeConstraints {
            $0.centerY.equalTo(phoneTextField)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(46)
            $0.width.equalTo(109)
        }

        phoneField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(BaseSpacing.Base.s48)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-BaseSpacing.Base.s8)
        }

        codeField.snp.makeConstraints {
            $0.top.equalTo(phoneField.snp.bottom).offset(BaseSpacing.Base.s10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview()
        }

        timeLeftLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(BaseSpacing.Base.s16)
        }

        helpCallout.snp.makeConstraints {
            $0.leading.trailing.equalTo(codeTextField)
            $0.bottom.equalTo(doneButton.snp.top).offset(-BaseSpacing.Base.s24)
        }

        doneButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension PhoneVerifyView {
    
    internal func bindOutput(
        _ output: PhoneVerifyViewModel.Output,
        cancelBag: CancelBag
    ) {
        
        output.isSent
            .withUnretained(self)
            .sink { owner, isSent in
                let text = isSent ? Self.i18N.resendButtonTitle : Self.i18N.sendButtonTitle
                ToastUtils.showMDSToast(type: .success, text: Self.i18N.sendSuccessToast)
                owner.setSendButtonTitle(text)
                owner.codeField.isHidden = !isSent
            }
            .store(in: cancelBag)
        
        output.phoneTextFieldText
            .asDriver()
            .withUnretained(self)
            .sink { owner, text in
                owner.phoneTextField.text = text
            }
            .store(in: cancelBag)
        
        output.codeTextFieldText
            .asDriver()
            .withUnretained(self)
            .sink { owner, text in
                owner.codeTextField.text = text
            }
            .store(in: cancelBag)
        
        output.timerIsRunning
            .withUnretained(self)
            .sink { owner, active in
                self.endEditing(!active)
                self.codeTextField.isEnabled = active
            }
            .store(in: cancelBag)
        
        output.phoneFailDescription
            .withUnretained(self)
            .sink { owner, description in
                owner.updateFailLabelUI(isCode: false, description)
            }
            .store(in: cancelBag)
        
        output.codeFailDescription
            .withUnretained(self)
            .sink { owner, description in
                owner.updateFailLabelUI(isCode: true, description)
            }
            .store(in: cancelBag)
        
        output.sendButtonIsEnabled
            .withUnretained(self)
            .sink { owner, isEnabled in
                owner.sendButton.isEnabled = isEnabled
                owner.sendButton.backgroundColor = isEnabled ? SemanticColor.Bg.Neutral.inverse : SemanticColor.Bg.Neutral.Default.disabled
            }
            .store(in: cancelBag)
        
        output.doneButtonIsEnabled
            .withUnretained(self)
            .sink { owner, isEnabled in
                owner.doneButton.isEnabled = isEnabled
            }
            .store(in: cancelBag)
        
        output.timeLeft
            .withUnretained(self)
            .sink { owner, timeLeft in
                owner.timeLeftLabel.text = timeLeft.to_mmss
                owner.refreshTimeLeftLabel()
            }
            .store(in: cancelBag)
        
        output.shouldWaitForCoolTime
            .withUnretained(self)
            .sink { owner, coolTime in
                ToastUtils.showMDSToast(type: .alert, text: "\(coolTime)초 후에 다시 시도하세요.")
            }
            .store(in: cancelBag)
    }
    
    private func updateFailLabelUI(isCode: Bool, _ description: String?) {
        let field = isCode ? codeField : phoneField
        field.errorMessage = description

        if isCode {
            isTimeLeftError = description != nil
            refreshTimeLeftLabel()
        }
    }

    private func refreshTimeLeftLabel() {
        let color = isTimeLeftError ? SemanticColor.Fg.Danger.default : SemanticColor.Fg.Neutral.bold
        timeLeftLabel.setTypography(Typography.body1, textColor: color)
    }

    private func setSendButtonTitle(_ text: String) {
        sendButton.setAttributedTitle(
            NSAttributedString(
                string: text,
                attributes: Typography.label3.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.inverse)
            ),
            for: .normal
        )
        sendButton.setAttributedTitle(
            NSAttributedString(
                string: text,
                attributes: Typography.label3.attributedStringAttributes(foregroundColor: SemanticColor.Fg.Neutral.Default.disabled)
            ),
            for: .disabled
        )
    }
}

private extension UIView {
    func firstSubview<T: UIView>(ofType type: T.Type) -> T? {
        for subview in subviews {
            if let matched = subview as? T {
                return matched
            }
            if let matched = subview.firstSubview(ofType: type) {
                return matched
            }
        }
        return nil
    }
}
