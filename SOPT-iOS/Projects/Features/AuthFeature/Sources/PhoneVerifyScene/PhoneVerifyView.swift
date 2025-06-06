//
//  SignUpPhoneVerifyView.swift
//  AuthFeature
//
//  Created by 장석우 on 1/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import DSKit
import Core


final class PhoneVerifyView: UIView {
    
    public var helpViewHidden: Bool {
        get { helpView.isHidden }
        set { helpView.isHidden = newValue }
    }
    
    public var viewModelInput: PhoneVerifyViewModel.Input {
        return .init(
            sendButtonTapped: sendButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            doneButtonTapped: doneButton.publisher(for: .touchUpInside).mapVoid().asDriver(),
            phoneTextFieldText: phoneTextField.publisher(for: .editingChanged).compactMap { $0.text }.asDriver(),
            codeTextFieldText: codeTextField.publisher(for: .editingChanged).compactMap { $0.text }.asDriver()
        )
    }
    
    public var loginHelpButtonTapped: Driver<Void> {
        helpView.gesture().mapVoid().asDriver()
    }
    
    private static let i18N = I18N.Auth.PhoneVerify.self
    
    private let titleLabel = UILabel().then {
        $0.text = i18N.title
        $0.font = DSKitFontFamily.Suit.bold.font(size: 24)
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = i18N.description
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray60.color
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let phoneLabel = UILabel().then {
        $0.text = i18N.phoneLabel
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray80.color
    }
    
    private let phoneTextField = UITextField().then {
        $0.placeholder = i18N.phonePlaceholder
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.keyboardType = .numberPad
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.textColor = DSKitAsset.Colors.gray10.color
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.addToolbar()
        $0.addLeftPadding(width: 20)
    }
    
    private let phoneFailIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.alertCircle.image.withTintColor(DSKitAsset.Colors.error.color)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let phoneFailLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.error.color
        $0.isHidden = true
    }
    
    private let sendButton = AppImageTextButton(title: i18N.sendButtonTitle).then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let codeTextField = UITextField().then {
        $0.placeholder = i18N.codePlaceholder
        $0.font = DSKitFontFamily.Suit.medium.font(size: 16)
        $0.keyboardType = .numberPad
        $0.backgroundColor = DSKitAsset.Colors.gray800.color
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.isHidden = true
        $0.addToolbar()
        $0.addLeftPadding(width: 20)
        $0.addRightPadding(width: 63)
    }
    
    private let timeLeftLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.medium.font(size: 14)
        $0.textColor = DSKitAsset.Colors.white.color
        $0.text = i18N.defaultTimerText
    }
    
    private let codeFailIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.alertCircle.image.withTintColor(DSKitAsset.Colors.error.color)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let codeFailLabel = UILabel().then {
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.error.color
        $0.isHidden = true
    }
    
    private let helpView = UIView().then {
        $0.backgroundColor = DSKitAsset.Colors.blue400.color.withAlphaComponent(0.1)
        $0.layer.borderColor = DSKitAsset.Colors.blue400.color.withAlphaComponent(0.6).cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let infoIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.infoCircle.image.withTintColor(
            DSKitAsset.Colors.blue500.color
        )
        $0.contentMode = .scaleAspectFit
    }
    
    private let helpTitleLabel = UILabel().then {
        $0.text = i18N.helpTitle
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 14)
        $0.textColor = DSKitAsset.Colors.gray30.color
    }
    
    private let chevronRightIcon = UIImageView().then {
        $0.image = DSKitAsset.Assets.chevronRight.image.withTintColor(
            DSKitAsset.Colors.gray30.color
        )
        $0.contentMode = .scaleAspectFit
    }
    
    private let helpDescriptionLabel = UILabel().then {
        $0.text = i18N.helpDescription
        $0.font = DSKitFontFamily.Suit.semiBold.font(size: 12)
        $0.textColor = DSKitAsset.Colors.gray200.color
        $0.numberOfLines = 0
    }
    
    private let doneButton = AppImageTextButton(title: i18N.doneButtonTitle).then {
        $0.configuration?.attributedTitle?.font = DSKitFontFamily.Suit.semiBold.font(size: 18)
    }
    
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
            phoneLabel,
            phoneTextField,
            phoneFailIcon,
            phoneFailLabel,
            sendButton,
            codeTextField,
            codeFailIcon,
            codeFailLabel,
            helpView,
            doneButton
        )
        
        codeTextField.addSubview(timeLeftLabel)
        
        helpView.addSubviews(
            infoIcon,
            helpTitleLabel,
            chevronRightIcon,
            helpDescriptionLabel
        )
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(phoneLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        phoneFailIcon.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(8)
            $0.leading.equalTo(phoneTextField)
            $0.size.equalTo(14)
        }
        
        phoneFailLabel.snp.makeConstraints {
            $0.centerY.equalTo(phoneFailIcon)
            $0.leading.equalTo(phoneFailIcon.snp.trailing).offset(4)
            $0.trailing.equalTo(codeTextField)
        }
        
        sendButton.snp.makeConstraints {
            $0.centerY.equalTo(phoneTextField)
            $0.leading.equalTo(phoneTextField.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(110)
            $0.height.equalTo(phoneTextField)
        }
        
        codeTextField.snp.makeConstraints {
            $0.top.equalTo(phoneFailLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(phoneTextField)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        timeLeftLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        codeFailIcon.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(8)
            $0.leading.equalTo(codeTextField)
            $0.size.equalTo(14)
        }
        
        codeFailLabel.snp.makeConstraints {
            $0.centerY.equalTo(codeFailIcon)
            $0.leading.equalTo(codeFailIcon.snp.trailing).offset(4)
            $0.trailing.equalTo(codeTextField)
        }
        
        helpView.snp.makeConstraints {
            $0.top.equalTo(codeFailLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(codeTextField)
        }
        
        infoIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(18)
            $0.size.equalTo(20)
        }
        
        helpTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(infoIcon)
            $0.leading.equalTo(infoIcon.snp.trailing).offset(10)
        }
        
        chevronRightIcon.snp.makeConstraints {
            $0.centerY.equalTo(helpTitleLabel)
            $0.leading.equalTo(helpTitleLabel.snp.trailing)
            $0.size.equalTo(16)
        }
        
        helpDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(helpTitleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(helpTitleLabel)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
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
                owner.sendButton.updateTitle(text)
                owner.codeTextField.isHidden = !isSent
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
        
        output.timeLeft
            .withUnretained(self)
            .sink { owner, time in
                print(time)
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
            }
            .store(in: cancelBag)
    }
    
    private func updateFailLabelUI(isCode: Bool, _ description: String?) {
        let failLabel = isCode ? codeFailLabel : phoneFailLabel
        let failIcon = isCode ? codeFailIcon : phoneFailIcon
        let textfield = isCode ? codeTextField : phoneTextField
        failLabel.text = description
        failIcon.isHidden = description == nil
        failLabel.isHidden = description == nil
        textfield.layer.borderColor = description == nil ? UIColor.clear.cgColor : DSKitAsset.Colors.error.color.cgColor
        
        if isCode {
            timeLeftLabel.textColor = description == nil ? DSKitAsset.Colors.white.color : DSKitAsset.Colors.error.color
        }
    }
}
